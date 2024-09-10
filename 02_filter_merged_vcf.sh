#!/bin/bash

#SBATCH --account=utu
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=19:00:00
#SBATCH -o out.varfilter-%j.txt-%N
#SBATCH -e err.varfilter-%j.txt-%N



# Author: Baylee Christensen
# Date: 09/04/2024
# Description: This script first filters the vcf file for quality. Then, it cuts the merged vcf file with the gff file generated through MiCGiG, where the matches create mito_etc and the nonmatches go into a different vcf file
# Usage for cmd line: nohup bash 02_filter_merged_vcf.sh
# Usage for sbatch: sbatch 02_filter_merged_vcf.sh


VCF_FILE_PATH=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/vcf_output/merged_output.vcf
GFF_FILE_PATH=/uufs/chpc.utah.edu/common/home/u6057891/whiptail_dge_tissues/MiCFiG.gff

module load bedops/2.4.41

attr_filtration_gff() {
    local gff_file=$GFF_FILE_PATH
    local bed_file=${gff_file%.gff}.bed

    # Use bedops to convert gff to bed
    gff2bed < "$gff_file" > "$bed_file"

    # Retain gene attribute from the gff and add them to the bed file
    # 1. Split the 9th column by semicolon to extract attributes
    # 2. Extract pattern between '|' and '_'
    # 3. Add the extracted blast_id to the BED file

    awk -v OFS='\t' '
    BEGIN { FS = "\t" }
    {
        split($9, attributes, ";");  
        for (i in attributes) {
            if (attributes[i] ~ /blast_id=/) {
                match(attributes[i], /sp\|[^|]+\|([^_]+)_/, id);  
                blast_id = id[1];  
            }
        }
        print $1, $2, $3, $4, $5, $6, blast_id;  # Add the extracted blast_id to the BED file
    }' "$gff_file" > "${bed_file}.temp"

    # Compress and index the final BED file
    #bgzip "$bed_file"
    #tabix -p bed "${bed_file}.gz"
}

# Call function
attr_filtration_gff

module unload bedops/2.4.41
