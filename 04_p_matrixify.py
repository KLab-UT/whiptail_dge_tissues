import csv
import argparse

parser = argparse.ArgumentParser(description="Parse VCF and BED data and output a CSV.")
parser.add_argument("-i", "--input_file", required=True, help="Input VCF/BED file")
parser.add_argument("-o", "--output_file", required=True, help="Output CSV file")
args = parser.parse_args()



def parse_vcf_bed(vcf_bed_file, output_csv):
    with open(vcf_bed_file, 'r') as infile, open(output_csv, 'w', newline='') as outfile:
        writer = csv.writer(outfile)
        # Write CSV header
        writer.writerow(["SampleID", "Chromosome", "Position", "Gene", "RefAD", "AltAD", "DeltaAD", "GT:PL"])
        
        for line in infile:
            line = line.strip().split()
            
            # Extract necessary fields from the VCF line
            chromosome = line[0]  # Chromosome
            position = line[1]    # Position
            dp4_field = line[7].split('DP4=')[1].split(';')[0]  # Extract DP4 values
            gene = line[-1]       # Gene from BED section (last column)
            dp4_values = list(map(int, dp4_field.split(',')))  # Split DP4 values and convert to int
            
            # Calculate RefAD, AltAD, and DeltaAD
            ref_ad = dp4_values[0] + dp4_values[1]  # First two values
            alt_ad = dp4_values[2] + dp4_values[3]  # Last two values
            delta_ad = alt_ad - ref_ad  # DeltaAD
            
            # SampleID starts from 1 for column 9 and goes to column 26
            sample_id_start = 1

            for sample_id in range(sample_id_start, sample_id_start + 18):
                gt_pl_value = line[sample_id + 8]
                writer.writerow([sample_id, chromosome, position, gene, ref_ad, alt_ad, delta_ad, gt_pl_value])

if __name__ == "__main__":
    parse_vcf_bed(args.input_file, args.output_file)
