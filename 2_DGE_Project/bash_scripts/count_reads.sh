#!/bin/bash

#subread is loaded to run 'featureCounts'

module load subread

# Define the path to the annotation file which is the [reference genome]
reference_file="/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/Reference/a_marmoratus_AspMarm2.0_v1.gtf"

#######################################################
# Creating Counts [creating one file gene_counts.txt] #
#######################################################

featureCounts -a $reference_file -o gene_counts.txt *.bam

module unload subread

