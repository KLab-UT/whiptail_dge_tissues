#!/bin/bash

#SBATCH --account=utu
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=19:00:00
#SBATCH -o out.varcutting-%j.txt-%N
#SBATCH -e err.varcutting-%j.txt-%N



# Author: Baylee Christensen
# Date: 09/04/2024
# Description: This script cuts the merged vcf file with the gff file generated through MiCGiG, where the matches create mito_etc and the nonmatches go into a different vcf file
# Usage for cmd line:
# Usage for sbatch:


VCF_FILE_PATH=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/vcf_output/merged_output.vcf
GFF_FILE_PATH=/uufs/chpc.utah.edu/common/home/u6057891/whiptail_dge_tissues/MiCFiG.gff

# Since gff file is 0 based, we must subtract the coordinates by one and transfer it into a bed file for easier processing.
awk '{OFS="\t"; print $1, $4-1, $5}' $GFF_FILE_PATH > MiCFiG.bed
