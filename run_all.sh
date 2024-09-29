#!/bin/bash

#SBATCH --account=utu
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=59:00:00
#SBATCH -o out.runall-%j.txt-%N
#SBATCH -e err.runall-%j.txt-%N




log_success() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - SUCCESS: $1"
}

log_failure() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - FAILURE: $1"
}

execute_command() {
    command=$1
    description=$2

    if $command; then
        log_success "$description"
    else
        log_failure "$description"
        exit 1  # Exit script if command fails
    fi
}

# Run each script with logging
execute_command "bash 00_call_variants.sh /uufs/chpc.utah.edu/common/home/u6057891/whiptail_dge_tissues/mapped_reads" "Running 00_call_variants.sh"
execute_command "bash 01_merge_vcf.sh /scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/vcf_output" "Running 01_merge_vcf.sh"
execute_command "bash 02_filter_merged_vcf.sh" "Running 02_filter_merged_vcf.sh"
execute_command "bash 03_splice_files.sh" "Running 03_splice_files.sh"
execute_command "bash 04_matrixify.sh -v /scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/spliced_vcfs/rd_mito_gene_matches.vcf -o /scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/matrix/mito_variants.csv -f gene_match" "Running 04_matrixify.sh for mito variants"
execute_command "bash 04_matrixify.sh -v /scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/spliced_vcfs/rd_no_mito_gene_matches.vcf -o /scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/matrix/no_mito_variants.csv -f no_match" "Running 04_matrixify.sh for no mito variants"

