#!/bin/bash

{
usage="$(basename "$0") [-h][-g <reference_genome>][-d <repository_directory>] [-w <working_directory>] [-t <number_of_processors>]"
usage+="\nThis program will trim and map merged reads from given SRA sequences files to compare mapping of different NGS datasets."
usage+="\n    -h  show this help text"
usage+="\n    -g  The reference genome (in fasta format). It is assumed that the genome is within the References directory in -d"
usage+="\n    -d  Path to the repository directory (the path to the repository you cloned from github)"
usage+="\n    -w  Path to the working directory (where processed files will be stored)"
usage+="\n    -t  Number of CPU processors"

options=':h:g:t:d:w:'
while getopts $options option; do
  case "$option" in
    h) echo "$usage"; exit;;
    g) g=$OPTARG;;
    t) t=$OPTARG;;
    d) d=$OPTARG;;
    w) w=$OPTARG;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
    \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
  esac
done

##########################
# Load necessary modules #
##########################

module load bwa/2020_03_19
module load samtools/1.16

##########################
# Index reference genome #
##########################

echo "Indexing Reference"
echo ""
cd "${d}"
bwa index "${g}"

# Align merged reads against reference
echo "Aligning Merged Reads against Reference with bwa mem, using $t threads."
echo ""

# our samples were titled "Am_01_merged..."
# This creates both merged and unmerged mapped sam and bam files

cd "${w}/cleaned_reads/merged_reads"
for merged_read in *.fastq.gz; do
    sample_name=$(echo $merged_read | cut -d "_" -f "1,2" )
    bwa mem "${g}" $merged_read > "${w}/mapped_reads/${sample_name}_merged_mapped.sam"
    bwa mem "${g}" ../unmerged_reads/"${sample_name}"_unmerged1.fastq ../unmerged_reads/"${sample_name}"_unmerged2.fastq > "${w}/mapped_reads/${sample_name}_unmerged_mapped.sam"
    samtools sort "${w}/mapped_reads/${sample_name}_merged_mapped.sam" > "${w}/mapped_reads/${sample_name}_merged_sorted.bam" -@ "${t}"
    samtools sort "${w}/mapped_reads/${sample_name}_unmerged_mapped.sam" > "${w}/mapped_reads/${sample_name}_unmerged_sorted.bam" -@ "${t}"
done

##################
# Unload modules #
##################

module unload bwa/2020_03_19
module unload samtools/1.16

########
# DONE #
########

echo "Alignment completed successfully."

# Record execution stats
end=$(date +%s)
elapsed=$((end - begin))
echo "Time taken: $elapsed"

mdate=$(date +'%d/%m/%Y %H:%M:%S')
mcpu=$((100-$(vmstat 1 2|tail -1|awk '{print $15}')))
mmem=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
echo "$mdate | $mcpu | $mmem" >> ./stats-cpu
} | tee logfile

