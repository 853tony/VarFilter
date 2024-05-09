#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J gnomADv2.0_vcf_info

#SBATCH -p ngs186G

#SBATCH -c 28

#SBATCH --mem=186g

#SBATCH -o ../../log_gnomadv4.0.0_dir/gnomADv2.0_vcf_info.out.log

#SBATCH -e ../../log_gnomadv4.0.0_dir/gnomADv2.0_vcf_info.err.log

#SBATCH --mail-user=d12456001@g.ntu.edu.tw

#SBATCH --mail-type=ALL

module add biology/bcftools/1.13
bcftools -v

datadir=$1
wkdir=$2
scrdir=$3

subdir="stats"

mkdir -p ${wkdir}/${subdir}

echo "script from ${scrdir}"
echo "output to ${wkdir}/${subdir}"

gunzip -c "${datadir}/gnomad.exomes.r2.1.1.sites.vcf.gz" | tee "${wkdir}/${subdir}/gnomad.exomes.r2.1.1.sites.vcf" | bcftools stats > "${wkdir}/${subdir}/gnomad.exomes.r2.1.1.sites.stats.txt"
 
