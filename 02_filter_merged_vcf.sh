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
module load htslib/1.18
module load bcftools/1.16
module load vcftools

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

    # Overwrite file with new data
    mv "${bed_file}.temp" "$bed_file"

    # Compress and index the final BED file
    bgzip "$bed_file"
    tabix -p bed "${bed_file}.gz"
}

# Call function
attr_filtration_gff


hard_variant_filtration {
  # Step 1: Get rid of low-quality (mean) genotyping:
    vcftools --vcf "$1".vcf --out "$2"_HardFilterStep1 --minGQ 20 --recode --recode-INFO-all
    mv "$2"_HardFilterStep1.recode.vcf "$2"_HardFilterStep1.vcf
    echo "Post genotype Quality filtration $2 variants: $(grep -v "^#" "$2"_HardFilterStep1.vcf | wc -l)" >> Log.txt
  # Step 2: Get rid of low-depth individuals per site
    vcftools --vcf "$2"_HardFilterStep1.vcf --out "$2"_HardFilterStep2 --minDP 10 --recode --recode-INFO-all
    mv "$2"_HardFilterStep2.recode.vcf "$2"_HardFilterStep2.vcf
    echo "Post depth filtration $2 variants: $(grep -v "^#" "$2"_HardFilterStep2.vcf | wc -l)" >> Log.txt
  # Step 3: Get rid of multiallelic SNPs (more than 2 alleles):
    bcftools view -m2 -M2 -v snps "$2"_HardFilterStep3.vcf > "$2"_HardFilterStep4.vcf
    echo "Post multiallelic filtration $2 variants: $(grep -v "^#" "$2"_HardFilterStep4.vcf | wc -l)" >> Log.txt
  # Step 4: Get rid of low-frequency alleles- here just singletons:
    vcftools --mac 2 --vcf "$2"_HardFilterStep4.vcf --recode --recode-INFO-all --out "$2"_HardFilterStep5
    mv "$2"_HardFilterStep5.recode.vcf "$2"_HardFilterStep5.vcf
    echo "Post singleton filtration $2 variants: $(grep -v "^#" "$2"_HardFilterStep5.vcf | wc -l)" >> Log.txt
  # Step 5: Remove sites missing high amounts of data
    vcftools --max-missing 0.3 --vcf "$2"_HardFilterStep5.vcf --recode --recode-INFO-all --out "$2"_HardFilterStep6
    mv "$2"_HardFilterStep6.recode.vcf "$2"_HardFilterStep6.vcf
    echo "Post removal of sites with high missing data: $(grep -v "^#" "$2"_HardFilterStep6.vcf | wc -l)" >> Log.txt
  # Finishing: Compress data
    bgzip "$2"_HardFilterStep6.vcf
    bcftools index -f "$2"_HardFilterStep6.vcf.gz
  # Move all stuff to it's own directory
    mkdir -p hard_filter_files
    mv *HardFilter* hard_filter_files

}


# Call function
#attr_filtration_gff
hard_variant_filtration $VCF_FILE_PATH

module unload bedops/2.4.41
module unload htslib/1.18
module unload bcftools/1.16
module unload vcftools
