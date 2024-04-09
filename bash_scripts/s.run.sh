#!/bin/bash

#SBATCH --account=utu
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH -o slurm-%j.out-%N
#SBATCH -e slurm-%j.err-%N

bash environment_setup.sh
bash trims_rna_reads.sh
