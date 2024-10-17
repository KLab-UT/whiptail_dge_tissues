# Script for grabbing all synonyms of genes names, creating list of them, and 
# also for creating dictionary later on
setwd('~/Library/CloudStorage/OneDrive-UtahTechUniversity/School/Research/whiptail_dge_tissues/BioGrid_Interactions')
install.packages('devtools')
library('devtools')
install_github('oganm/geneSynonym')
library('geneSynonym')

goi <- readLines('~/Library/CloudStorage/OneDrive-UtahTechUniversity/School/Research/whiptail_dge_tissues/BioGrid_Interactions/37_mito_genes.txt')
goi <- gsub('"', '', goi)
goi <- unlist(strsplit(goi, ",\\s*"))


geneSynonym::taxData
geneSynonym(goi, tax = 9606)


# Get the results from the geneSynonym function
synonym_results <- geneSynonym(goi, tax = 9606)

# Initialize an empty list for the dictionary
gene_dict <- list()

# Initialize an empty vector for the list of all genes and aliases
all_genes_and_aliases <- c()

# Loop through each gene in the results
for (gene in names(synonym_results)) {
  # Check if the gene has any aliases
  gene_ids <- names(synonym_results[[gene]])
  
  if (length(gene_ids) == 0) {
    # No aliases: Use the original gene name as both key and value
    original_name <- gene
    gene_dict[[original_name]] <- original_name
    all_genes_and_aliases <- c(all_genes_and_aliases, original_name)
  } else {
    # Aliases are present: Use the original name and its aliases
    gene_id <- gene_ids[1]  # Extract the first ID (the main gene group)
    original_name <- synonym_results[[gene]][[gene_id]][1]  # First element is the original name
    
    # Add original name to dictionary and list
    gene_dict[[original_name]] <- original_name
    all_genes_and_aliases <- c(all_genes_and_aliases, original_name)
    
    # Loop through the aliases and add them to the dictionary
    for (alias in synonym_results[[gene]][[gene_id]]) {
      gene_dict[[alias]] <- original_name
      all_genes_and_aliases <- c(all_genes_and_aliases, alias)
    }
  }
}

# Convert the compiled list of genes and aliases into a formatted string
all_genes_and_aliases_str <- paste0('"', paste(all_genes_and_aliases, collapse = '","'), '"')

# Print the resulting dictionary and formatted string
print("Dictionary of aliases to original names:")
print(gene_dict)

print("Compiled list of all genes and aliases in desired format:")
print(all_genes_and_aliases_str)

# Create a data frame from the dictionary
gene_dict_df <- data.frame(Alias = names(gene_dict), Original = unlist(gene_dict), stringsAsFactors = FALSE)

# Save the dictionary as a CSV file
write.csv(gene_dict_df, "gene_alias_dictionary.csv", row.names = FALSE)

# Save the list of all genes and aliases as a text file
write(all_genes_and_aliases_str, file = "genes_and_aliases_list.txt")

# Output messages
print("Dictionary saved as 'gene_alias_dictionary.csv'")
print("List of all genes and aliases saved as 'genes_and_aliases_list.txt'")
