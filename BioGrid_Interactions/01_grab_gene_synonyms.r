# Script for grabbing all synonyms of gene names, creating a list and dictionary
# for future use

# Load necessary libraries
setwd('~/Library/CloudStorage/OneDrive-UtahTechUniversity/School/Research/whiptail_dge_tissues/BioGrid_Interactions')
if (!require('devtools')) install.packages('devtools')
library('devtools')
if (!require('geneSynonym')) install_github('oganm/geneSynonym')
library('geneSynonym')

# Parse command-line arguments
args <- commandArgs(trailingOnly = TRUE)
input_file <- NULL

# Check for -i flag and set input_file if provided
for (i in seq_along(args)) {
  if (args[i] == "-i" && i + 1 <= length(args)) {
    input_file <- args[i + 1]
  }
}

# Raise an error if the input file is not specified
if (is.null(input_file)) {
  stop("Error: Please provide an input file with the -i flag. Usage: Rscript 01_grab_gene_synonyms -i <input_file>")
}

# Function to process gene synonyms and create outputs
process_gene_synonyms <- function(input_file) {
  # Read and format gene list
  goi <- readLines(input_file)
  goi <- gsub('"', '', goi)
  goi <- unlist(strsplit(goi, ",\\s*"))

  # Fetch gene synonym data
  synonym_results <- geneSynonym(goi, tax = 9606)

  # Initialize dictionary and list
  gene_dict <- list()
  all_genes_and_aliases <- c()

  # Loop through each gene in results
  for (gene in names(synonym_results)) {
    gene_ids <- names(synonym_results[[gene]])
    if (length(gene_ids) == 0) {
      original_name <- gene
      gene_dict[[original_name]] <- original_name
      all_genes_and_aliases <- c(all_genes_and_aliases, original_name)
    } else {
      gene_id <- gene_ids[1]
      original_name <- synonym_results[[gene]][[gene_id]][1]

      gene_dict[[original_name]] <- original_name
      all_genes_and_aliases <- c(all_genes_and_aliases, original_name)

      for (alias in synonym_results[[gene]][[gene_id]]) {
        gene_dict[[alias]] <- original_name
        all_genes_and_aliases <- c(all_genes_and_aliases, alias)
      }
    }
  }

  # Format unique gene and alias list as a string
  all_genes_and_aliases <- unique(all_genes_and_aliases)
  all_genes_and_aliases_str <- paste0('"', paste(all_genes_and_aliases, collapse = '","'), '"')

  # Output file names based on input file name
  base_name <- tools::file_path_sans_ext(basename(input_file))
  dict_output_file <- paste0(base_name, "_gene_alias_dictionary.csv")
  alias_list_output_file <- paste0(base_name, "_genes_and_aliases_list.txt")

  # Print the resulting dictionary and formatted string
  print("Dictionary of aliases to original names:")
  print(gene_dict)

  print("Compiled list of all genes and aliases in desired format:")
  print(all_genes_and_aliases_str)

  # Save outputs
  gene_dict_df <- data.frame(Alias = names(gene_dict), Original = unlist(gene_dict), stringsAsFactors = FALSE)
  write.csv(gene_dict_df, dict_output_file, row.names = FALSE)
  write(all_genes_and_aliases_str, file = alias_list_output_file)

  # Output messages
  cat("Dictionary saved as:", dict_output_file, "\n")
  cat("List of all genes and aliases saved as:", alias_list_output_file, "\n")
}

# Run the function with the specified input file
process_gene_synonyms(input_file)

