#!/bin/bash

source /opt/asn/etc/asn-bash-profiles-special/modules.sh
module load samtools 
module load bwa/0.7.12
#module load bcftools/1.2
#module laod python/2.7.1



REF=lizard
REF2=whiptail
echo $REF
echo $REF2


GATK2=/scratch/aubclsb0336/PROJECT2/GATK2

#mkdir $GATK2
cd $GATK2
#/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk --list

#cp ../lizard/$REF.fasta .
#cp ../whiptail/$REF2.fasta .
ls -al ./${REF}.fasta
ls -al ./${REF2}.fasta

#samtools faidx $REF.fasta
#bwa index "$GATK2"/"$REF".fasta -p ./${REF}_bwa_index
#pwd
#echo /opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk CreateSequenceDictionary -R ./${REF}.fasta -O ./${REF}.dict

#/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk CreateSequenceDictionary -R ./${REF}.fasta -O ./${REF}.dict



#samtools faidx $REF2.fasta
#bwa index "$GATK2"/"$REF2".fasta -p ./${REF2}_bwa_index
#/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk CreateSequenceDictionary -R ./${REF2}.fasta -O  ./${REF2}.dict
 
while read i;
do
#	bwa mem -t 4 -R '@RG\tID:foo\tPL:Illumina\tSM:'${REF}'_bwa_index' $GATK2/${REF}_bwa_index /scratch/aubclsb0336/PROJECT/CleanData/"$i"_1_paired.fastq /scratch/aubclsb0336/PROJECT/CleanData/"$i"_2_paired.fastq | samtools view -Sb - > ./"$i".bam
	samtools sort -@ 4 -m 4G -O bam -o $GATK2/"$i"_sorted.bam ./"$i".bam
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk MarkDuplicates -I ./"$i"_sorted.bam -O "$i"_markdup.bam -M "$i"_markdup_metrics.txt
	samtools index ./"$i"_markdup.bam
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk HaplotypeCaller -R $REF.fasta -I "${i}"_markdup.bam -O "${i}".vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk HaplotypeCaller -R $REF.fasta -I "${i}"_markdup.bam -ERC GCVF -O "${i}".g.vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk SelectVariants --select-type SNP -V "${i}".vcf -O "${i}"_snp.vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk VariantFiltration -V "${i}"_snp.vcf --filter-expression "QD < 2.0 || MQ < 40.0 || FS > 60.0 || SOR > 3.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "Filter" -O "${i}".snp.filter.vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk SelectVariants --select-type INDEL -V "${i}".vcf -O "${i}"_indel.vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk VariantFiltration -V "${i}"_indel.vcf --filter-expression "QD < 2.0 || FS > 200.0 || SOR > 10.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "Filter" -O "${i}".indel.filter.vcf 
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk MergeVcfs -I "${i}".indel.filter.vcf -I "${i}".snp.filter.vcf -O "$i".filter.vcf

done<list

mkdir $GATK/$REF
cp *bam ./$REF
cp *vcf ./$REF

while read i;
do
	bwa msem -t 4 -R '@RG\tID:foo\tPL:Illumina\tSM:'${REF2}'_bwa-index' $GATK2/${REF2}_bwa_index /scratch/aubclsb0336/PROJECT/CleanData/"$i"_1_paired.fastq /scratch/aubclsb0336/PROJECT/CleanData/"$i"_2_paired.fastq | samtools view -Sb - > ./"$i".bam
	samtools sort -@ 4 -m 4G -O bam -o $GATK2/"$i"_sorted.bam $GATK/"$i".bam
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk MarkDuplicates -I ./"$i"_sorted.bam -O "$i"_markdup.bam -M "$i"_markdup_metrics.txt
	samtools index ./"$i"_markdup.bam
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk HaplotypeCaller -R $REF2.fasta -I "${i}"_markdup.bam -O "${i}".vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk HaplotypeCaller -R $REF2.fasta -I "${i}"_markdup.bam -ERC GCVF -O "${i}".g.vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk SelectVariants --select-type SNP -V "${i}".vcf -O "${i}"_snp.vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk VariantFiltration -V "${i}"_snp.vcf --filter-expression "QD < 2.0 || MQ < 40.0 || FS > 60.0 || SOR > 3.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "Filter" -O "${i}".snp.filter.vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk SelectVariants --select-type INDEL -V "${i}".vcf -O "${i}"_indel.vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk VariantFiltration -V "${i}_indel.vcf --filter-expression "QD < 2.0 || FS > 200.0 || SOR > 10.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "Filter" -O "${i}".indel.filter.vcf
	/opt/asn/apps/gatk_4.1.0.0/gatk-4.1.0.0/gatk MergeVcfs -I "${i}".indel.vcf -I "${i}".snp.filter.vcf -O "$i".filter.vcf
done
mkdir $GATK/$REF2
cp *bam ./$REF2
cp *vcf ./$REF2

