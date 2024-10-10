#!/bin/bash

# Grabbed the mitochondrial genes from this website: https://www.ncbi.nlm.nih.gov/gene/?term=Homo+sapiens+mitochondrial



INPUT_FILE=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/gene_result.txt
# Sort to only have homo sapiens (for some reason all were grabbed)

#awk -F'\t' '$2 ~ /Homo/' $INPUT_FILE> filtered_output.txt

FIRST_FILE=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/filtered_output.txt
SECOND_FILE=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/matrix/combined_variants.csv
OUT_DIR=/scratch/general/nfs1/utu_4310/whiptail_dge_working_directory/

awk -F',' -v second_file="$FIRST_FILE" '
    BEGIN {
        OFS = ","; 
        # Read second file into an array
        while (getline < second_file) {
            if (NR > 1) { 
                gene = $4; 
                data[gene] = $0;  # Store all columns for each gene in the array
            }
        }
    }
    # Process the first file and check if the gene from column 7 matches the gene in second file
    {
        gene = $7; 
        if (gene in data) {
            print $0, data[gene];  # Print the matching row from both files
        }
    }
' $SECOND_FILE > ${OUT_DIR}/spliced_output.csv

