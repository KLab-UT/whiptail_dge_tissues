import csv
# Need to grab trna-synthetase genes from mitocarta and add in to aliases
# Gene list (input from the provided data)
gene_data = """
IARS2 - CAGSSS, ILERS, Q9NSE4
LARS2 - HLASA, LEURS, PRLTS$, mtLeuRS, Q15031
GATB - COXPD41, HSPC199, PET112, PET112L, O75879
YARS2 - CGI-04, MLASA2, MT-TYRRS, TYRRS, Q9Y2Z4
FARS2 - COXPD14, FARS1, HSPC320, PheRS, SPG77, mtPheRS, O95363
MARS2 - COXPD25, MetRS, mtMetRS, Q96GW9
GATC - COXPD42, O43716
WARS2 - NEMMLAS, TrpRS, mtTrpRS, Q9UGM6
DARS2 - ASPRS, LBSL, MT-ASPRS, mtAspRS, Q6PI48
CARS2 - COXPD27, cysRS, Q9HA77
NARS2 - DFNB94, SLM5, asnRS, Q96I59
VARS2 - COXPD20, VALRS, VARS2L, VARSL, Q5ST30
SARS2 - SARS, SARSM, SERS, SYS, SerRS, SerRSmt, mtSerRS, Q9NP8
EARS2 - COXPD12, MSE1, gluRS, mtGlnRS, Q5JPH6
HARS2 - HARSL, HARSR, HO3, HisRS, PRLTS2, P49590
RARS2 - ArgRS, DALRD2, PCH6, PRO1992, RARSL, Q5T160
TARS2 - COXPD21, TARSL1, thrRS, Q9BW92
AARS2 - AARSL, COXPD8, LKENP, MT-ALARS, MTALARS, Q5JTZ9
QRSL1 - COXPD40, GatA, Q9H0R6
GARS1 - CMT2D, DSMAV, GARS, GlyRS, HMN5, SMAD1, P41250
PARS2 - EIEE75, MT-PRORS, proRS, Q7L3T8
KARS1 - CMTRIB, DFNB89, KARS, KARS2, KRS, Q15046
"""

# Path to the dictionary CSV file
dictionary_file = "gene_alias_dictionary.csv"
gene_list_file = "genes_and_aliases_list.txt"

# Function to process gene list and append to file
def process_genes_and_append_to_file(gene_data, dictionary_file):
    alias_dict = {}
    all_genes_and_aliases = []

    # Process the input data
    for line in gene_data.strip().split("\n"):
        original_gene, aliases = line.split(" - ")
        aliases_list = [alias.strip() for alias in aliases.split(",")]

        # Append the original gene and aliases to the list
        all_genes_and_aliases.append(f'"{original_gene}"')
        all_genes_and_aliases.extend([f'"{alias}"' for alias in aliases_list])

        # Add to the dictionary where alias is the key, and the original gene is the value
        for alias in aliases_list:
            alias_dict[alias] = original_gene

    # Write the genes and aliases to a comma-separated file
    with open(gene_list_file, "a") as f:
        f.write(",".join(all_genes_and_aliases) + "\n")

    # Update the existing dictionary CSV file
    with open(dictionary_file, "a", newline="") as f:
        writer = csv.writer(f, quoting=csv.QUOTE_ALL)  # Ensure quoting around each entry
        for alias, original in alias_dict.items():
            writer.writerow([alias, original])

# Run the function
process_genes_and_append_to_file(gene_data, dictionary_file)

print("Genes and aliases have been processed and appended.")

