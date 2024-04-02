#!/bin/bash

#SBATCH --account=utu
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH -o slurm-%j.out-%N
#SBATCH -e slurm-%j.err-%N

touch map_reads.sh
touch slurm.sh
touch trim_rna_reads.sh
touch variant_call.sh

