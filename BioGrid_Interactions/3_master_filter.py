import pandas as pd

# Load the CSV files
variants_df = pd.read_csv('rd_mito_variants_NCBI_symbol.csv', sep=',')  # Adjust sep if necessary
interactions_df = pd.read_csv('2_filtered_interactions.csv')

# Strip any whitespace from column names
variants_df.columns = variants_df.columns.str.strip()
interactions_df.columns = interactions_df.columns.str.strip()

# Print column names to debug
print("Variants Columns:", variants_df.columns)
print("Interactions Columns:", interactions_df.columns)

# Initialize lists to store interaction data
interaction_binary = []  # Binary interaction flag
interaction_details = []  # Interacting gene and source

# Iterate through each row in the variants dataframe
for index, row in variants_df.iterrows():
    gene = row['Official_Symbol']
    interaction_flag = 0  # Default is no interaction
    interaction_info = "NA"  # Default is empty

    # Check for matches in the interactions dataframe
    matches_a = interactions_df['OFFICIAL_SYMBOL_A'] == gene
    matches_b = interactions_df['OFFICIAL_SYMBOL_B'] == gene

    if matches_a.any() or matches_b.any():
        interaction_flag = 1  # Set interaction flag to 1
        # Find the matching interaction(s)
        matching_rows = interactions_df.loc[matches_a | matches_b]

        # Extract interaction details (interacting gene and source)
        details = []
        for _, interact_row in matching_rows.iterrows():
            if interact_row['OFFICIAL_SYMBOL_A'] != gene:
                details.append(f"{interact_row['OFFICIAL_SYMBOL_A']} (source: {interact_row['INTERACTION_ID']})")
            elif interact_row['OFFICIAL_SYMBOL_B'] != gene:
                details.append(f"{interact_row['OFFICIAL_SYMBOL_B']} (source: {interact_row['INTERACTION_ID']})")

        interaction_info = "; ".join(details)  # Combine all interaction details

    # Append results to the lists
    interaction_binary.append(interaction_flag)
    interaction_details.append(interaction_info)

# Add the results to the variants dataframe
variants_df['Interaction_Binary'] = interaction_binary
variants_df['Interaction_Gene'] = interaction_details

# Save the new dataframe to a CSV file
variants_df.to_csv('final_interactions.csv', index=False)

print("Processing complete. Results saved to 'final_interactions.csv'.")

