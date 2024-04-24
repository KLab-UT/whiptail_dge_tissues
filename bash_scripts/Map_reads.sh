#!/bin/bash

{
usage="$(basename "$0") [-h][-g <reference_genome>][-w <working_directory>] [-t <number_of_processors>]"
usage+="\nThis program will trim and map merged reads from given SRA sequences files to compare mapping of different NGS datasets."
usage+="\n    -h  show this help text"
usage+="\n    -w  Path to the working directory (where processed files will be stored)"
usage+="\n    -t  Number of CPU processors"

options=':h:g:t:w:'
while getopts $options option; do
  case "$option" in
    h) echo "$usage"; exit;;
    t) t=$OPTARG;;
    w) w=$OPTARG;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
    \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
  esac
done

##########################
# Load necessary modules #
##########################

module load gffread/0.12.7
module load star/2.7.10a
module load samtools/1.16

##########################
# Index reference genome #
##########################

echo "Indexing Reference"
echo ""
cd "${w}"
cd "${w}"/Reference

###################################
# convert gff to gtf for indexing #
###################################

# This can be passed over if the file is already a .gtf file.

gffread -T a_marmoratus_AspMarm2.0_v1.gff -o a_marmoratus_AspMarm2.0_v1.gtf

################
# index genome #
################

STAR --runThreadN 8 --runMode genomeGenerate --genomeDir "${w}"/Reference --genomeFastaFiles "${g}" --sjdbGTFfile "${w}"/Reference/a_marmoratus_AspMarm2.0_v1.gtf --sjdbOverhang 100

#############
# map reads #
#############

# This creats .bam files for the merged and the unmerged reads, .sam files are not created. 
# Our original samples were titled "Am_01_merged..."

echo "Aligning Merged Reads against Reference with STAR, using $t threads."
echo ""

cd "${w}"/cleaned_reads/merged_reads
for merged_read in *.fastq.gz; do
    sample_name=$(echo $merged_read | cut -d "_" -f "1,2" )

# map merged clean reads
STAR --genomeDir "${w}"/Reference \
      --runThreadN 8 \
      --readFilesIn  "${w}"/cleaned_reads/merged_reads/$merged_read \
      --readFilesCommand zcat \
      --outSAMtype BAM SortedByCoordinate \
      --quantMode GeneCounts \
      --outFileNamePrefix "${w}"/mapped_reads/${sample_name}_merged_

# map unmerged clean reads
STAR --genomeDir "${w}"/Reference \
      --runThreadN 8 \
      --readFilesIn  "${w}"/cleaned_reads/unmerged_reads/${sample_name}_unmerged1.fastq \
                     "${w}"/cleaned_reads/unmerged_reads/${sample_name}_unmerged1.fastq \
      --readFilesCommand zcat \
      --outSAMtype BAM SortedByCoordinate \
      --quantMode GeneCounts \
      --outFileNamePrefix "${w}"/mapped_reads/${sample_name}_unmerged_

done

##################
# Unload modules #
##################

module unload star/2.7.10a
module unload samtools/1.16
module unload gffread/0.12.7

echo "Alignment completed successfully."

##########################
# Record execution stats #
##########################

end=$(date +%s)
elapsed=$((end - begin))
echo "Time taken: $elapsed"

mdate=$(date +'%d/%m/%Y %H:%M:%S')
mcpu=$((100-$(vmstat 1 2|tail -1|awk '{print $15}')))
mmem=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
echo "$mdate | $mcpu | $mmem" >> ./stats-cpu
} | tee logfile

