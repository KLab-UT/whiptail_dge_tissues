import pandas as pd

# Load the CSV files
variants_df = pd.read_csv('combined_variants.csv', sep=',', quotechar='"')  # Adjust sep if necessary
interactions_df = pd.read_csv('2_filtered_interactions.csv')

# Strip any whitespace from column names
variants_df.columns = variants_df.columns.str.strip()
interactions_df.columns = interactions_df.columns.str.strip()

# Print column names to debug
print("Variants Columns:", variants_df.columns)
print("Interactions Columns:", interactions_df.columns)

# Initialize a list to store interaction results
interaction_results = []

# Iterate through each row in the variants dataframe
for index, row in variants_df.iterrows():
    gene = row['Gene']
    interaction = 'no_interaction(0)'  # Default value

    # Check for exact matches in the interactions dataframe
    matches_a = interactions_df['Official_Symbol_Interactor_A'] == gene
    matches_b = interactions_df['Official_Symbol_Interactor_B'] == gene

    if matches_a.any() or matches_b.any():
        # Find the matching interaction(s)
        interacting_genes = interactions_df.loc[matches_a | matches_b, ['Official_Symbol_Interactor_A', 'Official_Symbol_Interactor_B']]

        # Create a string with interactions
        for _, interact_row in interacting_genes.iterrows():
            if interact_row['Official_Symbol_Interactor_A'] != gene:
                interaction = f"{interact_row['Official_Symbol_Interactor_A']}_Interaction(1)"
            elif interact_row['Official_Symbol_Interactor_B'] != gene:
                interaction = f"{interact_row['Official_Symbol_Interactor_B']}_Interaction(1)"
            break  # Only need one interaction for the new column

    interaction_results.append(interaction)

# Add the interaction results to the variants dataframe
variants_df['Interaction'] = interaction_results

# Save the new dataframe to a CSV file
variants_df.to_csv('final_interactions.csv', index=False)

