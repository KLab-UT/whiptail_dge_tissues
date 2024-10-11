#!/bin/bash



VARIANT_PATH=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/matrix/rd_mito_variants_updated.csv
MITO_GENE_PATH=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/matrix/37_mito_genes.csv
# Grab only unique genes from mito from rd_mito_variants_updated.csv
cut -d',' -f4 $VARIANT_PATH | sort | uniq | paste -sd ',' > unique_gene_list.txt

# Format 37 mito genes so in appropriate format for gene interaction API
awk 'NR > 1 { sub(/^MT-/, "", $1); print "\"" $1 "\"" }' $MITO_GENE_PATH | paste -sd, - > 37_mito_genes.txt

