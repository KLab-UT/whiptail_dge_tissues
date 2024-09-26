#!/bin/bash

# Author: Baylee Christensen
# Date: 9/26/24
# Desc: Marking duplicates of all BAM files.

INPUT_DIRECTORY="/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/mapped_reads"
OUTPUT_DIRECTORY="/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/mapped_reads"
module load picard

for bam_file in "$BAM_DIR"/Am_??.bam; do
	base_name=$(basename "$bam_file" .bam)

	output_file="$OUTPUT_DIR/${base_name}_removed_duplicates.bam"

        # Run Picard MarkDuplicates
        picard MarkDuplicates \
            I="$bam_file" \
            O="$output_file" \
            M="$OUTPUT_DIR/${base_name}_metrics.txt" \
	    REMOVE_DUPLICATES=true \
            VALIDATION_STRINGENCY=SILENT

	echo "Processed $bam_file -> $output_file"
done
module unload picard
