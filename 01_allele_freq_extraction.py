# Allele freq extraction from gnomADv4.0.

from cyvcf2 import VCF
import pandas as pd
import os
from tqdm import tqdm
import sys
import importlib.metadata
import subprocess
import shutil

#Before installing Cyvcf2, we had to install the package Htslib-1.9.
print('\n', 'cyvcf2 version: ', importlib.metadata.version('cyvcf2'), sep='')
print('pandas version: ', importlib.metadata.version('pandas'), sep='')
print('tqdm version: ', importlib.metadata.version('tqdm'), '\n', sep='')


if len(sys.argv) < 3:
    print("Usage: python script.py <datadir> <wkdir>")
    sys.exit(1)

datadir = sys.argv[1]
current_dir = sys.argv[2]

#datadir = "/your/data/path"	#when you don't use master-run.sh, plz type the path here
#current_dir = "/your/work/path"#when you don't use master-run.sh, plz type the path here

############################################

def process_vcf(input_vcf):
    # Open the VCF file for reading
    vcf_reader = VCF(input_vcf)
    # idx_test = 0		#test

    # Initialize an empty list to store variant data
    variants_box = []

    # Iterate through each variant in the VCF file
    for variant in vcf_reader:
        # idx_test += 1		#test
        # if idx_test > 5: 	#test
        #     break		#test

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
        INFO_AC_joint = variant.INFO.get('AC_joint')
        INFO_AN_joint = variant.INFO.get('AN_joint')
        INFO_AF_joint = variant.INFO.get('AF_joint')
                
        INFO_AC_joint_XX = variant.INFO.get('AC_joint_XX')
        INFO_AN_joint_XX = variant.INFO.get('AN_joint_XX')
        INFO_AF_joint_XX = variant.INFO.get('AF_joint_XX')
                
        INFO_AC_joint_XY = variant.INFO.get('AC_joint_XY')
        INFO_AN_joint_XY = variant.INFO.get('AN_joint_XY')
        INFO_AF_joint_XY = variant.INFO.get('AF_joint_XY')

        INFO_AC_joint_eas = variant.INFO.get('AC_joint_eas')
        INFO_AN_joint_eas = variant.INFO.get('AN_joint_eas')
        INFO_AF_joint_eas = variant.INFO.get('AF_joint_eas')

        INFO_AC_joint_sas = variant.INFO.get('AC_joint_sas')
        INFO_AN_joint_sas = variant.INFO.get('AN_joint_sas')
        INFO_AF_joint_sas = variant.INFO.get('AF_joint_sas')

        INFO_AC_joint_mid = variant.INFO.get('AC_joint_mid')
        INFO_AN_joint_mid = variant.INFO.get('AN_joint_mid')
        INFO_AF_joint_mid = variant.INFO.get('AF_joint_mid')

        INFO_AC_joint_nfe = variant.INFO.get('AC_joint_nfe')
        INFO_AN_joint_nfe = variant.INFO.get('AN_joint_nfe')
        INFO_AF_joint_nfe = variant.INFO.get('AF_joint_nfe')

        INFO_AC_joint_fin = variant.INFO.get('AC_joint_fin')
        INFO_AN_joint_fin = variant.INFO.get('AN_joint_fin')
        INFO_AF_joint_fin = variant.INFO.get('AF_joint_fin')

        INFO_AC_joint_afr = variant.INFO.get('AC_joint_afr')
        INFO_AN_joint_afr = variant.INFO.get('AN_joint_afr')
        INFO_AF_joint_afr = variant.INFO.get('AF_joint_afr')

        INFO_AC_joint_ami = variant.INFO.get('AC_joint_ami')
        INFO_AN_joint_ami = variant.INFO.get('AN_joint_ami')
        INFO_AF_joint_ami = variant.INFO.get('AF_joint_ami')

        INFO_AC_joint_amr = variant.INFO.get('AC_joint_amr')
        INFO_AN_joint_amr = variant.INFO.get('AN_joint_amr')
        INFO_AF_joint_amr = variant.INFO.get('AF_joint_amr')

        INFO_AC_joint_asj = variant.INFO.get('AC_joint_asj')
        INFO_AN_joint_asj = variant.INFO.get('AN_joint_asj')
        INFO_AF_joint_asj = variant.INFO.get('AF_joint_asj')
                                         
        INFO_AC_joint_remaining = variant.INFO.get('AC_joint_remaining')
        INFO_AN_joint_remaining = variant.INFO.get('AN_joint_remaining')
        INFO_AF_joint_remaining = variant.INFO.get('AF_joint_remaining')
                                        
        # Append the variant data to the list
        variants_box.append({
            'CHROM': CHROM,
            'POS': POS,
            'ID': ID,
            'REF': REF,
            'ALT': ALT,
            'Consequence': consequence,
            'SYMBOL': gene,
            'AC_joint': INFO_AC_joint,
            'AN_joint': INFO_AN_joint,
            'AF_joint': INFO_AF_joint,
            'AC_joint_XX': INFO_AC_joint_XX,
            'AN_joint_XX': INFO_AN_joint_XX,
            'AF_joint_XX': INFO_AF_joint_XX,
            'AC_joint_XY': INFO_AC_joint_XY,
            'AN_joint_XY': INFO_AN_joint_XY,
            'AF_joint_XY': INFO_AF_joint_XY,
            'AC_joint_eas':INFO_AC_joint_eas,
            'AN_joint_eas':INFO_AN_joint_eas,
            'AF_joint_eas':INFO_AF_joint_eas,
            'AC_joint_sas':INFO_AC_joint_sas,
            'AN_joint_sas':INFO_AN_joint_sas,
            'AF_joint_sas':INFO_AF_joint_sas,
            'AC_joint_mid':INFO_AC_joint_mid,
            'AN_joint_mid':INFO_AN_joint_mid,
            'AF_joint_mid':INFO_AF_joint_mid,
            'AC_joint_nfe':INFO_AC_joint_nfe,
            'AN_joint_nfe':INFO_AN_joint_nfe,
            'AF_joint_nfe':INFO_AF_joint_nfe,
            'AC_joint_fin':INFO_AC_joint_fin,
            'AN_joint_fin':INFO_AN_joint_fin,
            'AF_joint_fin':INFO_AF_joint_fin,
            'AC_joint_afr':INFO_AC_joint_afr,
            'AN_joint_afr':INFO_AN_joint_afr,
            'AF_joint_afr':INFO_AF_joint_afr,
            'AC_joint_ami':INFO_AC_joint_ami,
            'AN_joint_ami':INFO_AN_joint_ami,
            'AF_joint_ami':INFO_AF_joint_ami,
            'AC_joint_amr':INFO_AC_joint_amr,
            'AN_joint_amr':INFO_AN_joint_amr,
            'AF_joint_amr':INFO_AF_joint_amr,
            'AC_joint_asj':INFO_AC_joint_asj,
            'AN_joint_asj':INFO_AN_joint_asj,
            'AF_joint_asj':INFO_AF_joint_asj,                        
            'AC_joint_remaining':INFO_AC_joint_remaining,
            'AN_joint_remaining':INFO_AN_joint_remaining,
            'AF_joint_remaining':INFO_AF_joint_remaining
        })

    # Convert the list of variants_box into a DataFrame
    return pd.DataFrame(variants_box)

def process_chromosome(chrom):
    filename = f'gnomad.exomes.v4.0.sites.chr{chrom}.vcf.bgz'
    inputvcf = os.path.join(datadir, filename)
    return process_vcf(inputvcf)

############################################

# List of chromosomes to process
chromosomes = list(range(1, 23)) + ['X', 'Y']

# Output path
tmpdir = os.path.join(current_dir,"tmp")
os.makedirs(tmpdir, exist_ok=True)

for chrom in tqdm(chromosomes, desc='Processing chromosomes'):
    print('\n')
    result = []
    result = process_chromosome(chrom)

# Save the DataFrame to a CSV file (tmpdir)
    outputname = f'MAF_chr{chrom}_gnomadv4_exomes.tsv'
    outputdir = os.path.join(tmpdir, outputname)
    result.to_csv(outputdir, sep='\t', index=False)
    print(f'\nChromosome {chrom} processing completed and saved to {outputdir}')

############################################
# Concatenate the DataFrames for each chromosome into a single DataFrame
finaloutputname = 'MAF_METADATA_gnomadv4_exomes.tsv'
finaloutputdir = os.path.join(current_dir, finaloutputname)
awk_command = f"awk 'FNR==1 && NR!=1{{next;}}{{print}}' {tmpdir}/MAF_chr*_gnomadv4_exomes.tsv > {finaloutputdir}"

subprocess.run(awk_command, shell=True, check=True)
shutil.rmtree(tmpdir)

