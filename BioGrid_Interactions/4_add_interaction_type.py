import pandas as pd

# D_list with the new gene symbols
D_list = [
    "POLRMT", "POLDIP2", "MTERF2", "MTRES1", "TEFM", "TFAM", "POLG", "MTPAP", "MTERF4", "MTERF3", "TFB1M",
    "TFB2M", "POLQ", "POLG2", "MTERF1", "PRIMPOL", "POLB"
]

# R_list with the new gene symbols
R_list = [
    "MRPL12", "MRPS35", "MRPL53", "MRPS27", "MRPL46", "MRPS23", "IARS2", "MRPS15", "MRPL34", "MRPL2", "LARS2",
    "MRPL43", "MRPL10", "MRPS2", "MRPL16", "MRPL40", "MRPS18A", "MRPL1", "MRPL4", "MRPL55", "MRPL44", "MRPS14",
    "MRPS17", "MRPL17", "MRPL11", "MRPL13", "MRPL33", "MRPS28", "MRPL28", "YARS2", "MRPL21", "MRPS9", "MRPL15",
    "MRPL24", "MRPS7", "MRPL3", "MRPS12", "MRPL49", "MRPL19", "MRPL36", "FARS2", "MRPS18C", "MARS2", "MRPL20",
    "MRPS21", "MRPL30", "MRPS34", "MRPL22", "MRPL47", "MRPL9", "WARS2", "MRPS16", "MRPS5", "MRPS26", "MRPL27",
    "MRPS10", "MRPL37", "MRPL41", "MRPS6", "MRPL23", "DARS2", "MRPL51", "MRPL32", "MRPS25", "CARS2", "MRPS30",
    "NARS2", "MRPL18", "VARS2", "MRPL54", "MRPL38", "MRPL58", "MRPL35", "MRPS11", "SARS2", "MRPL57", "EARS2",
    "HARS2", "MRPL50", "RARS2", "MRPL14", "MRPS24", "MRPS22", "MRPS33", "TARS2", "MRPL39", "MRPL45", "MRPS31",
    "AARS2", "MRPL42", "MRPS18B", "GARS1", "PARS2", "MRPL52", "KARS1", "MRPS36", "MRPL48"
]

# Load the CSV into a pandas DataFrame
input_file = 'final_interactions.csv'  # Replace with the actual path to your CSV file
df = pd.read_csv(input_file)

# Strip any leading/trailing whitespace from column names (in case of formatting issues)
df.columns = df.columns.str.strip()

# Add the "Interaction_Type" column based on the conditions
def assign_interaction_type(row):
    interaction_type = ""

    # If Interaction_Binary is 1, assign "P" to Interaction_Type
    if row['Interaction_Binary'] == 1:
        interaction_type += "P"

    # If the gene is in R_list or D_list, append the respective type
    if row['Official_Symbol'] in R_list:
        interaction_type += "R"
    elif row['Official_Symbol'] in D_list:
        interaction_type += "D"

    return interaction_type

# Apply the function to each row to create the new column
df['Interaction_Type'] = df.apply(assign_interaction_type, axis=1)

# Save the updated DataFrame to a new CSV
output_file = 'updated_file.csv'  # Replace with your desired output file name
df.to_csv(output_file, index=False)

print(f"Updated CSV saved to {output_file}")
