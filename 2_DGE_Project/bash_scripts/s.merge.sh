#!/bin/bash

#SBATCH --account=utu
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=36:00:00
#SBATCH -o slurm-%j.out-%N
#SBATCH -e slurm-%j.err-%N

cd /uufs/chpc.utah.edu/common/home/u1207142/Biol4310/Classwork/whiptail_dge_tissues/bash_scripts 
bash merge_merged_and_unmerged_merges.sh


