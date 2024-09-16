#!/bin/bash

#SBATCH --account=utu
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=19:00:00
#SBATCH -o out.matrixify-%j.txt-%N
#SBATCH -e err.matrixify-%j.txt-%N

# Author: Baylee Christensen
# Date: 09/13/2024
# Description: First, need to find out which lizards are assigned to which tissue type. Then, we output 3 matrixes containing a specific structure referenced in MeetingNotes.txt.  
# Usage for cmd line: 
# Usage for sbatch: 

VCF_BED_FILE_PATH=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/spliced_vcfs/mito_gene_matches.vcf
OUTPUT_FILE_PATH=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/matrix/combined_variants.csv
PY_SCRIPT_PATH=/uufs/chpc.utah.edu/common/home/u6057891/whiptail_dge_tissues

# Calls python script to output the combined matrix
python3 ${PY_SCRIPT_PATH}/04_p_matrixify.py -i $VCF_BED_FILE_PATH -o $OUTPUT_FILE_PATH 

echo "Complete"
