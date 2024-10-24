sed -i '' 's/\r//g' gene_alias_dictionary.csv
paste -sd, genes_and_aliases_list.txt > temp.txt && mv temp.txt genes_and_aliases_list.txt
