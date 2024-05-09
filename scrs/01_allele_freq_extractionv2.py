# Allele freq extraction from gnomADv2.0.

from cyvcf2 import VCF
import pandas as pd
import os
from tqdm import tqdm
import sys
import importlib.metadata
import subprocess
import shutil
import glob

#Before installing Cyvcf2, we had to install the package Htslib-1.9.

print('\n', 'cyvcf2 version: ', importlib.metadata.version('cyvcf2'), sep='')
print('pandas version: ', importlib.metadata.version('pandas'), sep='')
print('tqdm version: ', importlib.metadata.version('tqdm'), '\n', sep='')

if len(sys.argv) < 3:
    print("Usage: python script.py <datadir> <wkdir>")
    sys.exit(1)

datadir = sys.argv[1]
current_dir = sys.argv[2]

def process_vcf(input_vcf):
    # Open the VCF file for reading
    vcf_reader = VCF(input_vcf)
    
    # Initialize an empty list to store variant data
    variants_box = []
    
    # Iterate through each variant in the VCF file
    for variant in vcf_reader:
        
        # Extract basic variant information
        CHROM = variant.CHROM
        POS = variant.POS
        ID = variant.ID
        REF = variant.REF
        ALT = ','.join(map(str, variant.ALT))  # A variant may have multiple-alt alleles
        
        # Extract information from the 'vep' field
        INFO_vep = variant.INFO.get('vep')
        vep_part = INFO_vep.split('|')
        consequence = vep_part[1] # Consequence type
        gene = vep_part[3] # Gene symbol
        
        # Extract allele count and allele number
        INFO_AC = variant.INFO.get('AC')
        INFO_AN = variant.INFO.get('AN')
        INFO_AF = variant.INFO.get('AF')
        INFO_AC_female = variant.INFO.get('AC_female')
        INFO_AN_female = variant.INFO.get('AN_female')
        INFO_AF_female = variant.INFO.get('AF_female')
        INFO_AC_male = variant.INFO.get('AC_male')
        INFO_AN_male = variant.INFO.get('AN_male')
        INFO_AF_male = variant.INFO.get('AF_male')
        INFO_AC_eas = variant.INFO.get('AC_eas')
        INFO_AN_eas = variant.INFO.get('AN_eas')
        INFO_AF_eas = variant.INFO.get('AF_eas')
        INFO_AC_sas = variant.INFO.get('AC_sas')
        INFO_AN_sas = variant.INFO.get('AN_sas')
        INFO_AF_sas = variant.INFO.get('AF_sas')
        INFO_AC_nfe = variant.INFO.get('AC_nfe')
        INFO_AN_nfe = variant.INFO.get('AN_nfe')
        INFO_AF_nfe = variant.INFO.get('AF_nfe')
        INFO_AC_fin = variant.INFO.get('AC_fin')
        INFO_AN_fin = variant.INFO.get('AN_fin')
        INFO_AF_fin = variant.INFO.get('AF_fin')
        INFO_AC_afr = variant.INFO.get('AC_afr')
        INFO_AN_afr = variant.INFO.get('AN_afr')
        INFO_AF_afr = variant.INFO.get('AF_afr')
        INFO_AC_amr = variant.INFO.get('AC_amr')
        INFO_AN_amr = variant.INFO.get('AN_amr')
        INFO_AF_amr = variant.INFO.get('AF_amr')
        INFO_AC_asj = variant.INFO.get('AC_asj')
        INFO_AN_asj = variant.INFO.get('AN_asj')
        INFO_AF_asj = variant.INFO.get('AF_asj')
        
        # Append the variant data to the list
        variants_box.append({
            'CHROM': CHROM,
            'POS': POS,
            'ID': ID,
            'REF': REF,
            'ALT': ALT,
            'Consequence': consequence,
            'SYMBOL': gene,
            'AC': INFO_AC,
            'AN': INFO_AN,
            'AF': INFO_AF,
            'AC_female': INFO_AC_female,
            'AN_female': INFO_AN_female,
            'AF_female': INFO_AF_female,
            'AC_male': INFO_AC_male,
            'AN_male': INFO_AN_male,
            'AF_male': INFO_AF_male,
            'AC_eas':INFO_AC_eas,
            'AN_eas':INFO_AN_eas,
            'AF_eas':INFO_AF_eas,
            'AC_sas':INFO_AC_sas,
            'AN_sas':INFO_AN_sas,
            'AF_sas':INFO_AF_sas,
            'AC_nfe':INFO_AC_nfe,
            'AN_nfe':INFO_AN_nfe,
            'AF_nfe':INFO_AF_nfe,
            'AC_fin':INFO_AC_fin,
            'AN_fin':INFO_AN_fin,
            'AF_fin':INFO_AF_fin,
            'AC_afr':INFO_AC_afr,
            'AN_afr':INFO_AN_afr,
            'AF_afr':INFO_AF_afr,
            'AC_amr':INFO_AC_amr,
            'AN_amr':INFO_AN_amr,
            'AF_amr':INFO_AF_amr,
            'AC_asj':INFO_AC_asj,
            'AN_asj':INFO_AN_asj,
            'AF_asj':INFO_AF_asj,
        })
    
    # Convert the list of variants_box into a DataFrame
    return pd.DataFrame(variants_box)

############################################

# Output path
tmpdir = os.path.join(current_dir,"tmp")
os.makedirs(tmpdir, exist_ok=True)

# Get a list of VCF files in the datadir
vcf_files = glob.glob(os.path.join(datadir, "*.vcf.gz")) + \
            glob.glob(os.path.join(datadir, "*.vcf.bgz")) + \
            glob.glob(os.path.join(datadir, "*.vcf"))

for vcf_file in tqdm(vcf_files, desc='Processing VCF files'):
    print('\n')
    result = []
    result = process_vcf(vcf_file)
    
    # Save the DataFrame to a CSV file (tmpdir)
    outputname = f'MAF_{os.path.basename(vcf_file)}.tsv'
    outputdir = os.path.join(tmpdir, outputname)
    result.to_csv(outputdir, sep='\t', index=False)
    print(f'\nProcessing of {vcf_file} completed and saved to {outputdir}')

############################################

# Concatenate the DataFrames for each VCF file into a single DataFrame
finaloutputname = 'MAF_METADATA_gnomadv2_exomes.tsv'
finaloutputdir = os.path.join(current_dir, finaloutputname)

awk_command = f"awk 'FNR==1 && NR!=1{{next;}}{{print}}' {tmpdir}/MAF_*.tsv > {finaloutputdir}"
subprocess.run(awk_command, shell=True, check=True)

shutil.rmtree(tmpdir)
