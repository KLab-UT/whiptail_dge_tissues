# Get the file paths from the command-line arguments
args <- commandArgs(trailingOnly = TRUE)
combined_variants_path <- ifelse(length(args) > 0, args[1], "combined_variants.csv")
updated_variants_path <- ifelse(length(args) > 1, args[2], "updated_combined_variants.csv")

# Load the CSV files
combined_variants <- read.csv(combined_variants_path, stringsAsFactors = FALSE)
sample_info <- read.csv("sample_info.csv", stringsAsFactors = FALSE)  # Assuming sample_info.csv is in the working directory

# Merge data based on SampleID and add the GeneType column
merged_data <- merge(combined_variants, sample_info, by = "SampleID", all.x = TRUE)
merged_data$GeneType <- "Mito"

# Write the updated data to a CSV file
write.csv(merged_data, updated_variants_path, row.names = FALSE)

