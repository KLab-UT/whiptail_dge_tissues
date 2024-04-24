#!/bin/bash

# The name of this file was to be confusing as a JOKE
# This file merges the [merged] and [unmerged] and creates a new file that will be used to get more accurate count data.

##########################
# load necessary modules #
##########################

module load samtools
module load parallel

# you are going to cd into your {w}/mapped_reads

cd /scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/mapped_reads

# our data was Am_01 - Am_15 & Am_25 - Am_27 so we created a way to count these to run them in parallel
# this part can be skipped if you do not want your data immidiatley

seq1=$(seq -w 1 15)
seq2=$(seq -w 25 27)
seq="$seq1 $seq2"

echo $seq | tr ' ' '\n' | parallel samtools -f merge Am_{}.bam {}_unmerged_*.bam {}_merged*.bam

#################################################
# Merge the merge & unmerge into ultimate merge #
#################################################

# pretty much the useful part of the script that uses samtools to merge the two files for further use when counting.

for i in {01..27}; do
	samtools merge Am_"${i}".bam "${i}"_unmerged_*.bam "${i}"_merged*.bam
done

module unload samtools
