#!/bin/bash

##This script is used for analyze the raw data to the gene count csv file and transcript count csv file
##First load all the module used in Alabama super computer. 
source /opt/asn/etc/asn-bash-profiles-special/module.sh

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

#the name of the reference species
REF=whiptail
echo $REF

#make the directory
#this is the working folder 
WD=/scratch/Yifan/Lizard/whiptail
#this is the rawdat folder
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

mkdir $WD
mkdir $RD
mkdir $CD
mkdir $REFD
mkdir $MAPD
mkdir $COUNTSD
mkdir $RESULT
mkdir $CS
mkdir $CS2

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
ls | greap ".fq" | cut -d "_" -f 2 | sort | uniq > list
cp list $WD

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









