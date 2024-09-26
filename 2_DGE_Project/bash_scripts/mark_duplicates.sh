#!/bin/bash

#SBATCH --account=utu
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=19:00:00
#SBATCH -o out.rmdups-%j.txt-%N
#SBATCH -e err.rmdups-%j.txt-%N

# Author: Baylee Christensen
# Date: 9/26/24
# Desc: Removing duplicates of all BAM files.

INPUT_DIRECTORY="/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/mapped_reads"
OUTPUT_DIRECTORY="/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/mapped_reads"
module load picard

for bam_file in "$INPUT_DIRECTORY"/Am_??.bam; do
	base_name=$(basename "$bam_file" .bam)

	output_file="$OUTPUT_DIRECTORY/${base_name}_removed_duplicates.bam"

        # Run Picard MarkDuplicates
        java -Xmx8g -jar $PICARD MarkDuplicates \
            I="$bam_file" \
            O="$output_file" \
            M="$OUTPUT_DIRECTORY/${base_name}_metrics.txt" \
	    REMOVE_DUPLICATES=true \
            VALIDATION_STRINGENCY=SILENT

	echo "Processed $bam_file -> $output_file"
done
module unload picard
