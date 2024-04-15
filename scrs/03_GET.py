import argparse
import pandas as pd

def parse_arguments():
    parser = argparse.ArgumentParser(description='Analyze gene variants and consequences from a TSV file.')
    required = parser.add_argument_group('required')
    col = parser.add_argument_group('column name arguments')
    required.add_argument('-i','--inp', type=str, required=True, metavar='', help='Input TSV file')
    required.add_argument('-o','--outp', type=str, required=True, metavar='', help='Base name for output files')
    parser.add_argument('-CS','--consequence', action='store_true', help='Calculate consequence statistics')
    col.add_argument('-c', '--chrcol', type=str, default='CHROM', metavar='', help='Column name for chromosome')
    col.add_argument('-p', '--poscol', type=str, default='POS', metavar='', help='Column name for position')
    col.add_argument('-r', '--refcol', type=str, default='REF', metavar='', help='Column name for reference allele')
    col.add_argument('-a', '--altcol', type=str, default='ALT', metavar='', help='Column name for alternative allele')
    col.add_argument('-v', '--varcscol', type=str, default='Consequence', metavar='', help='Column name for variant consequence')
    col.add_argument('-g', '--genecol', type=str, default='SYMBOL', metavar='', help='Column name for gene symbol')
    return parser.parse_args()

def get_first_consequence(consequence_string):
    if pd.isna(consequence_string) or consequence_string.strip() == "":
        return "unknown"
    return consequence_string.split('&')[0]

def main():
    args = parse_arguments()

# Ensure required columns are included for reading
    columns_to_read = [args.chrcol, args.poscol, args.refcol, args.altcol, args.varcscol, args.genecol]

    df = pd.read_csv(args.inp, sep='\t', usecols=lambda c: c in columns_to_read)

# Process Consequences
    if args.consequence:
        df['Consequence'] = df['Consequence'].apply(get_first_consequence)

# Count variants per gene
    gene_variant_counts = df['SYMBOL'].value_counts()
    total_genes = gene_variant_counts.shape[0]

# Variants with and without gene name
    variants_with_gene = df.dropna(subset=['SYMBOL']).shape[0]
    variants_without_gene = df[df['SYMBOL'].isna()].shape[0]
    total_variants = df.shape[0]  # Total variants regardless of gene name

# Consequence statistics
    if args.consequence:
        consequence_counts = df['Consequence'].value_counts(dropna=False)  # Include Gene = NaN
        consequence_counts_with_gene = df.dropna(subset=['SYMBOL'])['Consequence'].value_counts()
        consequence_counts_without_gene = df[df['SYMBOL'].isna()]['Consequence'].value_counts()

# Write gene variants to .gvlist file
    gvlist_filename = f'{args.outp}.gvlist'
    with open(gvlist_filename, 'w') as gvlist_file:
        gvlist_file.write('# The Genomic Extraction Tool (GET) was produced by Tony Che, post on https://github.com/853tony/VarFilter\n')
        gvlist_file.write('# Gene-Specific Variant Counts\n')
        gvlist_file.write('# Each entry delineates a gene symbol followed by its associated count of variants.\n')
        gvlist_file.write('# Gene Symbol\tVariant Count\n')
        for gene, count in gene_variant_counts.items():
            gvlist_file.write(f'{gene}\t{count}\n')

# Write summary to .summary file
    summary_filename = f'{args.outp}.summary'
    with open(summary_filename, 'w') as summary_file:
    # Refining summary information presentation
        summary_file.write('# The Genomic Extraction Tool (GET) was produced by Tony Che, post on https://github.com/853tony/VarFilter\n')
        summary_file.write('# Summary of Genetic Variant Analysis\n')
        summary_file.write('# This document summarizes the analysis of gene variants and their consequences, derived from the provided dataset.\n\n')
        summary_file.write(f'Total Number of Variants: {total_variants}\n')
        summary_file.write(f'Your dataset covers genes (count uniquely): {total_genes}\n')
        summary_file.write(f'Variants Mapped to Known Genes: {variants_with_gene}\n')
        summary_file.write(f'Variants Not Mapped to Any Gene: {variants_without_gene}\n\n') 
        
        if args.consequence:
            summary_file.write('# Total Consequence statistics (regardless of gene name):\n')
            for term, count in consequence_counts.dropna().items():  # Exclude NaN for consequence stats
                summary_file.write(f'{term}\t{count}\t{(count/total_variants)*100:.2f}%\n')

            summary_file.write('\n# Consequence statistics for variants with gene name:\n')
            for term, count in consequence_counts_with_gene.items():
                summary_file.write(f'{term}\t{count}\t{(count/variants_with_gene)*100:.2f}%\n')

            summary_file.write('\n# Consequence statistics for variants without gene name:\n')
            for term, count in consequence_counts_without_gene.items():
                summary_file.write(f'{term}\t{count}\t{(count/variants_without_gene)*100:.2f}%\n')

if __name__ == '__main__':
    main()


