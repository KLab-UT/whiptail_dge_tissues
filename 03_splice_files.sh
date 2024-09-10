#!/bin/bash

#SBATCH --account=utu
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=19:00:00
#SBATCH -o out.splicefilter-%j.txt-%N
#SBATCH -e err.splicefilter-%j.txt-%N


#insert info here later

VCF_FILE_PATH=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/filtration/hard_filtration
BED_FILE_PATH=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/filtration/MiCFiG.bed.gz
