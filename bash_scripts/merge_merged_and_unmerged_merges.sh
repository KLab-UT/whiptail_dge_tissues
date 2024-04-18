#!/bin/bash
cd /scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/mapped_reads
module load samtools
for merged_read in *.bam; do
	sample_name=$(echo $merged_read | cut -d "_" -f 1)
	samtools merge $sample_name.bam ${sample_name}_unmerged_sorted.bam ${sample_name}_merged_sorted.bam
done
module unload samtools
