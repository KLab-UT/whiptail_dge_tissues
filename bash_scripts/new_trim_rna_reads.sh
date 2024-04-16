#!/bin/bash
#cd into the raw data for the project

## Move all of the raw reads from this directory into $d/raw_reads
## MOVE not COPY

echo ""
echo "Beginning script"
echo ""
usage="$(basename "$0") [-h] [-d <working_directory>]
Script to perform raw read preprocessing using fastp
    -h show this help text
    -d working directory"
options=':h:l:d:'
while getopts $options option; do
    case "$option" in
        h) echo "$usage"; exit;;
	d) d=$OPTARG;;
	:) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
       \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
     esac
done


begin=`date +%s`

echo "copy over raw reads for this project"
cd /scratch/general/nfs1/utu_4310/whiptail_shared_data/raw_rna_reads/01.RawData
for i in {01..15}
do
	cp Am_$i/*.gz $d/raw_reads
done
for i in {25..27}
do
	cp Am_$i/*.gz $d/raw_reads
done


echo "load required modules"
echo ""
module load fastqc/0.11.4
# fastqc loads the html website
module load fastp/0.20.1

echo "create file storing environment"
echo ""

###################################
# Quality check of raw read files #
###################################
echo "Perform quality check of raw read files\n"
echo ""

cd /scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/raw_reads

ls *.fq.gz | cut -d "_" -f 1,2  | uniq > sample_list.txt

while read i; do 
  	fastqc "$i"_1.fq.gz # insert description here
  	fastqc "$i"_2.fq.gz # insert description here
done<sample_list.txt

####################################################
# Trimming downloaded Illumina datasets with fastp #
####################################################

echo "Trimming downloaded Illumina datasets with fastp."
ls *.fq.gz | cut -d "." -f "1" | cut -d "_" -f "1,2" | sort | uniq > fastq_list
while read z ; do 
fastp -i "$z"_1.fq.gz -I "$z"_2.fq.gz \
      -m --merged_out ${d}/cleaned_reads/merged_reads/"$z"_merged.fastq \
      --out1 ${d}/cleaned_reads/unmerged_reads/"$z"_unmerged1.fastq --out2 ${d}/cleaned_reads/unmerged_reads/"$z"_unmerged2.fastq \
      -e 25 -q 15 \
      -u 40 -l 15 \
      --adapter_sequence AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
      --adapter_sequence_r2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
      -M 20 -W 4 -5 -3 \
      -c 
cd ../cleaned_reads/merged_reads
gzip "$z"_merged.fastq
cd ../../raw_reads
done<fastq_list
cd ..
echo ""



#######################################
# Quality check of cleaned read files #
#######################################

echo "Perform check of cleaned read files"
cd ${d}/cleaned_reads/merged_reads
pwd
while read i; do 
	fastqc "$i"_merged.fastq.gz # insert description here
done<${d}/raw_reads


######################
# Unload all modules #
######################

module unload fastqc/0.11.4
module unload fastp/0.20.1
