#!/bin/bash

#SBATCH --account=utu_4310
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=99:00:00
#SBATCH -o slurm-%j.out-%N
#SBATCH -e slurm-%j.err-%N

# Default working directory
WORK_DIR="."

# Function to show usage information
usage() {
    echo "Usage: $0 [-d <directory>]"
    echo "Options:"
    echo "  -d <directory>: Set the working directory (default: current directory)"
    exit 1
}

# Parse command-line options
while getopts "d:" opt; do
    case $opt in
        d)
            WORK_DIR=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# Shift the option index so that $1 now refers to the first non-option argument
shift $((OPTIND - 1))

# Set working directory
cd "$WORK_DIR" || { echo "Error: Directory '$WORK_DIR' not found"; exit 1; }

# Sets up the file structure for mapping results
bash environment_setup.sh

# Trims the reads and puts them in merged_reads
bash $WORK_DIR/bash_scripts/new_trim_rna_reads -d /scratch/general/nfs1/utu_4310/whiptail_dge_working_directory

# Maps the reads to the reference genome
# Ask syrus for what he used for this step
# something like bash $WORK_DIR/bash_scripts/map_reads_star.sh 

# Next we had to merge unmerged and merged reads, because there is pair gaps
cd $WORK_DIR/bash_scripts
bash merge_merged_and_unmerged_merges.sh
# Or you could run the command in parallel by submitting:
# 1. edit s.merge.sh and change to you working directory
# 2. Submitting sbatch s.merge.sh

# Next, we had to count the amount of reads at each location reads were mapped.
# This referent file will likely vary project to project
bash count_reads.sh

#Lastly, Dr. Klabacka helped us with some different statistical analyses, then we used R to generate several graphs.
# The R Script used can be found in the github repo, named "whiptail_dge_R_analysis.r"
