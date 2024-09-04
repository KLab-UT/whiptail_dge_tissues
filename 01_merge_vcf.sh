#!/bin/bash

#SBATCH --account=utu
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=45:00:00
#SBATCH -o out.varmerging-%j.txt-%N
#SBATCH -e err.varmerging-%j.txt-%N


# Author: Baylee Christensen
# Date: 09/04/2024
# Description: This script merges all vcf files from previous output (because we have multiple lizard vcf files) into one
# Usage for command line: 
# Usage for sbatch:

