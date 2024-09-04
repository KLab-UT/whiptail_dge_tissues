#!/bin/bash

##This script is used for analyze the raw data to the gene count csv file and transcript count csv file
##First load all the module used in Alabama super computer. 
source /opt/asn/etc/asn-bash-profiles-special/modules.sh

module load sra
module load fastqc/0.10.1
module load trimmomatic/0.39
module load hisat2
module load stringtie/2.2.1
module load gffcompare
module load python/2.7.1
module load gcc/9.3.0
module load samtools
module load bcftools/1.2
module load gffread/

#read the name of the reference in the txt file, so for sure you have a txt file which include the name of species you want
REF=$(cat ./Reference.txt)
echo $REF

#make the directory
#this is the working folder 
WD=/scratch/Yifan/Lizard/whiptail
#this is the rawdata folder
RD=$WD/RawData
#this is the folder for the data after trimmomatic
CD=$WD/CleanData
#this is the folder for the index of reference
REFD=$WD/$REF
#this is the folder for the result after alignement
MAPD=$WD/MAPD
#this is the folder for the counts after stringtie
COUNTSD=$WD/COUNTSD
#this is the folder for all the results
RESULT=$WD/RESULT
#this is the folder for the fastqc out of the raw data
CS=$WD/PreCleanQuality
#this is teh folder for the fastqc out of the clean data
CS2=$WD/PostCleanQuality

#create the diectory for the reference for bwa program
bwaREFD=$WD/bwaREFD
#create the diectory for the mapping after bwa program
bwaMAPD=$WD/bwaMAPD
#create the diectory for the result counting after bwa program
bwaRESULT=$WD/bwaRESULT




mkdir $WD
mkdir $RD
mkdir $CD
mkdir $REFD
mkdir $MAPD
mkdir $COUNTSD
mkdir $RESULT
mkdir $CS
mkdir $CS2
mkdir $bwaREFD
mkdir $bwaMAPD
mkdir $bwaRESULT

#######################################FASTQC#######################################################################
#The first step is fastqc, which can provide the quality of the data, the input is the raw data and the output is in the CS folder 
cd $RD
fastqc * --outdir=$CS

#tar all the file in the CS, which can be easily been download and checked 
cd $CS
tar cvzf $CS.gz $CS/*

########################################TRIMMOMATIC############################################################################
##The second step is trimmomatic, which can cut the low quality of the reads and the adapters. the input is the raw data and the out put is trimmed paired end and unpaired end reads
## get the list of the raw data first. the list can be used for the for cycle laterly. 
cd $RD
ls | grep ".fq" | cut -d "_" -f 2 | sort | uniq > list
cp list $WD
#make sure you have the AdaptersToTrim_All.fa in the home diectory
adapters=AdaptersToTrim_All.fa
cp ~/$adapters .

#start to trim the data 
while read i;
do
	java -jar /mnt/beegfs/home/aubmxa/.conda/envs/BioInfo_Tools/share/trimmomatic-0.39-1/trimmomatic.jar PE -threads 6 -phred33 \
	*"$i"_1.fq.gz *"$i"_2.fq.gz \
	$CD/"$i"_1_paired.fastq $CD/"$i"_1_unpaired.fastq $CD/"$i"_2_paired.fastq $CD/"$i"_2_unpaired.fastq \
	ILLUMINACLIP:AdaptersToTrim_All.fa:2:35:10 HEADCROP:10 LEADING:30 TRAILING:30 SLIDINGWINDOW:6:30 MINLEN:36

	#now do the fastqc folloing to check the quality result after trim
	fastqc $CD/"$i"_1_paired.fastq --outdir=$CS2
	fastqc $CD/"$i"_2_paired.fastq --outdir=$CS2
done < list

#Now compress the results files from CS2
cd $CS2
tar cvzf $CS2.tar.gz $CS2/*

################################HISAT2 ALIGNMENT#################################################################
#first build the index 
cd $REFD
#copy the reference genome, reference annotation file to this locations. 
cp ~/$REF* .

#Identify exons and splice sites
#If the genome is gff3 file formate, transfer the gff3 format to gtf format. OR CAN WE DIRECTLY HAVE THE GTF FORMAT
gffread $REF.gff3 -T -o $REF.gtf
extract_splice_sites.py $REF.gtf > $REF.ss
extract_exons.py $REF.gtf > $REF.exon

#build the hisat2 index
hisat2-build -p 10 $REF.fasta ${REF}_index

#then move to the mapping folder
cd $MAPD
cp $WD/list .

while read i;
do
	hisat2 -p 6 -dta --phred33 \
	-x "$REF"/${REF}_index \
	-1 "$CD"/"$i"_1_paired.fastq -2 "$CD"/"$i"_2_paired.fastq \
	-S "$i".sam
	
	#convert sam file into bam file
	samtools view -@ 6 -bS "$i".sam > "$i".bam
	#sort the bam
	samtools sort -@ 6 -T "$i"_sorted.temp -o "$i"_sorted.bam "$i".bam
	#index the bam file
	samtools flagstat "$i"_sorted.bam > "$i"_stats.txt
	
	#use stringtie to for counting
	mkdir $COUNTSD/$i
	stringtie -p 6 -e -B -G "%REFD"/"$REF".gff -o "$MAPD"/"$i"/"$i".gtf "$MAPD"/"$i"_sorted.bam
done < list

###put all the data in to the result folder
cp *.txt $RESULT
python ~/prepDE.py -i $COUNTSD
cp *.csv $RESULT


##alignment with bwa
cd $bwaREFD
cp $REFD/$REF.fasta .

#create the index for the bwa alignment 
bwa index $bwaREFD/$REF.fasta -p ./${REF}_bwa_index

cd $bwaMAPD
cp $WD/list .

while read i;
do
	bwa mem -t 4 -R '@RG\tID:foo\tPL:Illumina\tSM:'${REF}'_bwa_index' $bwaREFD/${REF}_bwa_index "$CD"/"$i"_1_paired.fastq "$CD"/"$i"_2_paired.fastq | samtools view -Sb - > ./$i.bam
	samtools sort -@ 6 "$i".bam "$i"_sorted
	samtools flagstat "$i"_sorted.bam > "$i"_Stats.txt
	
	mkdir "$bwaMAPD"/"$i"
	stringtie -p 6 -e -B -G $REFD/$REF.gtf -o "$bwaMAPD"/"$i"/"$i".gtf -l "$i" "$bwaMAPD"/"$i"_sorted.bam
done < list
cp *.txt $bwaRESULT
python ~/prepDE.py -i $bwaMAPD
cp *.csv $bwaRESULT

#GATK analysis
GATK=$WD/GATK
mkdir $GATK

cd $GATK
cp $WD/list .
cp $REFD/$REF.fasta .

samtools faidx $REF.fasta
/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk CreateSequenceDictionary -R "$GATK"/"REF".dict

while read i;
do
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk MarkDuplicates -I "$MAPD"/"$i"_sorted.bam -O "$i"_markdup.bam -M "$i"_markdup_metrics.txt
	samtools index ./"$i"_markdup.bam && echo "** index done **"
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk HaplotypeCaller -R $REF.fasta -I "${i}"_markdup.bam -O "${i}"vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk HaplotypeCaller -R $REF.fasta -I "${i}"_markdup.bam -ERC GVCF -O "${i}".g.vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk SelectVariants -select-type SNP -V "${i}".vcf -O "${i}"_snp.vcf && eccho "**snp done**"
    /opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk VariantFiltration -V "${i}"_snp.vcf --filer-expression "QD < 2.0 || MQ < 40.0 || FS > 60.0 || SOR > 3.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "Filter" -O "${i}".snp.filter.vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk SelectVariants --select-type INDEL -V "${i}".vcf -O "${i}"_indel.vcf
    /opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk VariantFiltration -V "${i}"_indel.vcf --filter-expression "QD < 2.0 || FS > 200.0 || SOR > 10.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "Filter" -O "${i}".indel.filter.vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk MergeVcfs -I "${i}".indel.filter.vcf -I "${i}".snp.filter.vcf -O "$i".filter.vcf
done < list

#joint the snp analysis together 
while read i;
do
echo "-I ${i}.vcf" >> test.txt
done  < list
test=`cat ./test.txt`
echo $test

/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk MergeVcfs $test -O ${REF}.vcf
/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk SelectVariants -R $REF.fasta -select-type SNP -V "${REF}".vcf -O "${REF}"_snp.vcf
/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk SelectVariants -R $REF.fasta -select-type INDEL -V "${REF}".vcf -O "${REF}"_indel.vcf
/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk VariantFiltration -V "${REF}"_snp.vcf --filter-expression "QD < 2.0 || MQ < 40.0 || FS > 60.0 || SOR > 3.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "Filter" -O "${REF}"_snp_filter.vcf
/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk VariantFiltration -V "${REF}"_indel.vcf --filter-expression "QD < 2.0 || FS > 200.0 || SOR > 10.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "Filter" -O "${REF}"_indel_filter.vcf
/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk MergeVcfs -I "${REF}"_indel_filter.vcf -I "${REF}"_snp_filter.vcf -O "${REF}"_filter.vcf

#filter with vcftools
mkdir $GATK/vcftools

cd $GATK/vcftools
cp ../Culex_quinquefasciatus2_filter.vcf .
~/vcftools_0.1.13/bin/vcftools --vcf $GATK/"${REF}"_filter.vcf --out ./"${REF}"_hardfilterstep1 --minGQ 20 --recode --recode-INFO-all
mv ./"${REF}"_hardfilterstep1.recode.vcf ./"${REF}"_hardfilterstep1.vcf
bcftools view -m2 -M2 -v snps ./"${REF}"_hardfilterstep1.vcf > ./"${REF}"_hardfilterstep2.vcf
~/vcftools_0.1.13/bin/vcftools --max-missing 0.3 --vcf ./Culex_quinquefasciatus2_hardfilterstep2.vcf --recode --recode-INFO-all --out ./Culex_quinquefasciatus2_hardfilterstep3
mv ./"${REF}"_hardfilterstep3.recode.vcf ./"${REF}"_hardfilterstep3.vcf
~/vcftools_0.1.13/bin/vcftools --mac 1 --vcf ./"${REF}"_hardfilterstep3.vcf --recode --recode-INFO-all --out ./"${REF}"_hardfilterstep4
mv ./"${REF}"_hardfilterstep4.recode.vcf ./"${REF}"_hardfilterstep4.vcf
ls ./"${REF}"_hardfilterstep4.vcf

bgzip "${REF}"_hardfilterstep4.vcf
bcftools index -f "${REF}"_hardfilterstep4.vcf.gz





#snpEff
module load java/17.0.1
smpEff=$WD/snpEff
mkdir $snpEff
cd $snpEff

while read i;
do
	mkdir ./"$i"
	cd ./"$i"
	java -jar ~/snpEff/snpEff.jar -v $REF $GATK/"$i".filter.vcf > "$i".snpeff.filter.vcf
	cd ..
done < list

java -jar ~/snpEff/snpEff.jar -v Culex_quinquefasciatus $GATK/vcftools/"${REF}"_hardfilterstep4.vcf > Culex_quinquefasciatus2_hardfilter_after_vcftools_snpeff.vcf







