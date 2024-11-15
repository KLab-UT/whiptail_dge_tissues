import pandas as pd
import pdb

# Load the CSV file into a DataFrame
df = pd.read_csv("complete_interaction_list.csv")


# List of genes to filter by
genes_of_interest = ["ATP8","MT-ATP8","ATPase8","MTATP8","ATP6","MT-ATP6","ATPase6","MTATP6","COX1","MT-CO1","COI","MTCO1","COX2","MT-CO2","COII","MTCO2","COX3","MT-CO3","COIII","MTCO3","CYTB","MT-CYB","MTCYB","ND1","MT-ND1","MTND1","ND2","MT-ND2","MTND2","ND3","MT-ND3","MTND3","ND4L","MT-ND4L","MTND4L","ND4","MT-ND4","MTND4","ND5","MT-ND5","MTND5","ND6","MT-ND6","MTND6","RNR2","MT-RNR2","MTRNR2","TRNA","MT-TA","MTTA","TRNR","MT-TR","MTTR","TRNN","MT-TN","MTTN","TRND","MT-TD","MTTD","TRNC","MT-TC","MTTC","TRNE","MT-TE","MTTE","TRNQ","MT-TQ","MTTQ","TRNG","MT-TG","MTTG","TRNH","MT-TH","MTTH","TRNI","MT-TI","MTTI","TRNL1","MT-TL1","MTTL1","TRNL2","MT-TL2","MTTL2","TRNK","MT-TK","MTTK","TRNM","MT-TM","MTTM","TRNF","MT-TF","TRNP","MT-TP","MTTP","TRNS1","MT-TS1","MTTS1","TRNS2","MT-TS2","MTTS2","TRNT","MT-TT","MTTT","TRNW","MT-TW","MTTW","TRNY","MT-TY","MTTY","TRNV","MT-TV","MTTV","RNR1","MT-RNR1","MTRNR1"]

# Create a mask to filter the DataFrame
mask = df['OFFICIAL_SYMBOL_A'].isin(genes_of_interest) | df['OFFICIAL_SYMBOL_B'].isin(genes_of_interest)

# Filter the DataFrame
filtered_df = df[mask]

# Save the filtered results to a new CSV file
filtered_df.to_csv("1_filtered_interactions.csv", index=False)

