function hard-VariantFiltration {
  # Step 1: Get rid of low-quality (mean) genotyping:
    vcftools --vcf "$1".vcf --out "$2"_HardFilterStep1 --minGQ 20 --recode --recode-INFO-all
    mv "$2"_HardFilterStep1.recode.vcf "$2"_HardFilterStep1.vcf
    echo "Post genotype Quality filtration $2 variants: $(grep -v "^#" "$2"_HardFilterStep1.vcf | wc -l)" >> Log.txt
  # Step 2: Get rid of multiallelic SNPs (more than 2 alleles):
    bcftools view -m2 -M2 -v snps "$2"_HardFilterStep1.vcf > "$2"_HardFilterStep2.vcf
    echo "Post multiallelic filtration $2 variants: $(grep -v "^#" "$2"_HardFilterStep2.vcf | wc -l)" >> Log.txt
  # Step 3: Get rid of low-frequency alleles- here just singletons:
    vcftools --mac 2 --vcf "$2"_HardFilterStep2.vcf --recode --recode-INFO-all --out "$2"_HardFilterStep3
    mv "$2"_HardFilterStep3.recode.vcf "$2"_HardFilterStep3.vcf
    echo "Post singleton filtration $2 variants: $(grep -v "^#" "$2"_HardFilterStep3.vcf | wc -l)" >> Log.txt
  # Step 4: Remove sites missing high amounts of data
    vcftools --max-missing 0.3 --vcf "$2"_HardFilterStep3.vcf --recode --recode-INFO-all --out "$2"_HardFilterStep4
    mv "$2"_HardFilterStep4.recode.vcf "$2"_HardFilterStep4.vcf
    echo "Post removal of sites with high missing data: $(grep -v "^#" "$2"_HardFilterStep4.vcf | wc -l)" >> Log.txt
  # Finishing: Compress data
    bgzip "$2"_HardFilterStep4.vcf
    bcftools index -f "$2"_HardFilterStep4.vcf.gz
