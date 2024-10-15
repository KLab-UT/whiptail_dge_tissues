#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import requests
import argparse
import json
from core import config as cfg

# Function to read genes from a file and return them as a list
def load_genes_from_file(filename):
    with open(filename, 'r') as file:
        gene_data = file.read().strip()
        return gene_data.replace('"', '').split(",")  # Remove quotes and split by comma

# Create a function to check if interaction is between genes in list_A and list_B
def is_valid_interaction(geneA, geneB, nucmit_list, mito_list):
    return (geneA in nucmit_list and geneB in mito_list) or (geneA in mito_list and geneB in nucmit_list)

# Main function that handles the request, filtering, and output
def main(nucmit_file, mito_file, output_file):
    # Load genes from the input files
    nucmit_list = load_genes_from_file(nucmit_file)
    mito_list = load_genes_from_file(mito_file)

    # Debugging: Print loaded gene lists
    print("Loaded nucmit_list:", nucmit_list)
    print("Loaded mito_list:", mito_list)

    # Prepare request URL and parameters
    request_url = cfg.BASE_URL + "/interactions"
    params = {
        "accesskey": cfg.ACCESS_KEY,
        "format": "tab2",  # Return results in TAB2 format
        "geneList": "|".join(nucmit_list + mito_list),  # Combine both gene lists for the search
        "searchNames": "true",  # Search against official names
        "includeInteractors": "true",  # Get any interaction involving EITHER gene
        "interSpeciesExcluded": "true",
        "taxId": 9606,
        "evidenceList": "POSITIVE GENETIC|PHENOTYPIC ENHANCEMENT",  # Example evidence types
        "includeEvidence": "false",
        "includeHeader": "true"
    }

    # Debugging
    print("Request URL:", request_url)
    print("Request params:", params)

    # Send request to BioGRID API
    response = requests.get(request_url, params=params)

    # Debugging: Print the response from the API
    print("API Response Status Code:", response.status_code)
    print("API Response Text (first 500 chars):", response.text[:500])
    interactions = response.text

    # Split response into lines (each line corresponds to an interaction)
    interaction_lines = interactions.split('\n')

    # Filter results to keep only interactions between nucmit_list and mito_list
    filtered_interactions = []
    for line in interaction_lines:
        columns = line.split('\t')
        if len(columns) > 8:  # Ensure there are enough columns to process
            geneA = columns[7]  # 'Official Symbol Interactor A'
            geneB = columns[8]  # 'Official Symbol Interactor B'

            # Debugging
            print(f"Checking interaction: {geneA} - {geneB}")
            # Check if the interaction is between a gene from nucmit_list and a gene from mito_list
            if is_valid_interaction(geneA, geneB, nucmit_list, mito_list):
                filtered_interactions.append(line)
                print(f"Valid interaction found {geneA} - {geneB}")
    print(f"Total filtered interactions: {len(filtered_interactions)}")

    # Output the filtered interactions to the specified file or stdout
    output = "\n".join(filtered_interactions)
    if output_file:
        with open(output_file, 'w') as f:
            f.write(output)
        print(f"Filtered interactions written to {output_file}")
    else:
        print(output)

# Argument parser for input/output files
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Fetch and filter gene interactions between two gene lists from BioGRID")

    parser.add_argument("-n", "--nucmit_file", type=str, default="unique_gene_list.txt",
                        help="Path to the file containing the first list of genes (default: 'unique_gene_list.txt')")
    parser.add_argument("-m", "--mito_file", type=str, default="37_mito_genes.txt",
                        help="Path to the file containing the second list of genes (default: '37_mito_genes.txt')")
    parser.add_argument("-o", "--output_file", type=str, default="output.txt",
                        help="Path to the output file to save filtered interactions (default: output.txt")

    args = parser.parse_args()

    # Call the main function with parsed arguments
    main(args.nucmit_file, args.mito_file, args.output_file)

