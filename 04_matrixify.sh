#!/bin/bash

#SBATCH --account=utu
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=29:00:00
#SBATCH -o out.matrixify-%j.txt-%N
#SBATCH -e err.matrixify-%j.txt-%N

# Author: Baylee Christensen
# Date: 09/13/2024
# Description: 
# Usage for cmd line: 
# Usage for sbatch: sbatch 04_matixify.sh -v /scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/spliced_vcfs/mito_gene_matches.vcf -o /scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/matrix/mito_variants.csv
# sbatch 04_matrixify.sh -v /scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/spliced_vcfs/no_mito_gene_matches.vcf -o /scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/matrix/no_mito_variants.csv

#VCF_BED_FILE_PATH=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/spliced_vcfs/mito_gene_matches.vcf
#OUTPUT_FILE_PATH=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/matrix/combined_variants.csv
PY_SCRIPT_PATH=/uufs/chpc.utah.edu/common/home/u6057891/whiptail_dge_tissues
R_SCRIPT_PATH=/uufs/chpc.utah.edu/common/home/u6057891/whiptail_dge_tissues

# Argument parser
while getopts v:o: flag
do
    case "${flag}" in
        v) VCF_BED_FILE_PATH=${OPTARG};;
        o) OUTPUT_FILE_PATH=${OPTARG};;
    esac
done

# Calls python script to output the combined matrix
python3 ${PY_SCRIPT_PATH}/04_p_matrixify.py -i $VCF_BED_FILE_PATH -o $OUTPUT_FILE_PATH 
Rscript ${R_SCRIPT_PATH}/04_r_matrixify.R $OUTPUT_FILE_PATH 

echo "Complete"
