#!/bin/bash

#SBATCH --account=utu
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=19:00:00
#SBATCH -o out.splicefilter-%j.txt-%N
#SBATCH -e err.splicefilter-%j.txt-%N


#insert info here later

VCF_FILE_PATH=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/vcf_output/merged_output.vcf
BED_FILE_PATH=/uufs/chpc.utah.edu/common/home/u6057891/whiptail_dge_tissues/MiCFiG.bed.gz
