# Run this script with the following command from the command line:
# Rscript 5_add_sublocalizations.R "$(pwd)"

library(dplyr)

# Capture the directory from the command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if the directory argument is provided
if (length(args) > 0) {
  setwd(args[1])
  cat("Working directory set to:", getwd(), "\n")
} else {
  cat("No directory argument provided. Using default working directory:", getwd(), "\n")
}

cat("Current working directory is:", getwd(), "\n")

# Import data
dat <- read.csv('final_interactions_with_type.csv')
# Import mitocarta information
mito_carta <- read.csv('../Human.MitoCarta3.0.csv')
# Create "Official_Symbol" field
mito_carta <- mito_carta %>%
  rename(Official_Symbol = Symbol)

# only include genes with interactions
dat_subset <- dat[dat$Interaction_Type != "", ]

# perform left join to add sublocalizations
dat_subset <- dat_subset %>%
  left_join(mito_carta %>% select(Official_Symbol, MitoCarta3.0_SubMitoLocalization),
            by = "Official_Symbol") %>%
  rename(SubLocalization = MitoCarta3.0_SubMitoLocalization)

# output file
write.csv(dat_subset, "final_interactions_with_SubLocalizations.csv", row.names = FALSE)

