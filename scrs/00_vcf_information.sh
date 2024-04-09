#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J gnomADv4.0_vcf_info

#SBATCH -p ngs186G

#SBATCH -c 28

#SBATCH --mem=186g

#SBATCH -o ./LOG/gnomADv4.0_vcf_info.out.log

#SBATCH -e ./LOG/gnomADv4.0_vcf_info.err.log

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

chromosomes=($(seq 1 22) X Y)

for i in "${chromosomes[@]}"
do
  gunzip -c "${datadir}/gnomad.exomes.v4.0.sites.chr${i}.vcf.bgz" | tee "${wkdir}/${subdir}/gnomad.exomes.v4.0.sites.chr${i}.vcf" | bcftools stats > "${wkdir}/${subdir}/gnomad.exomes.v4.0.chr${i}.stats.txt"
  
  echo "Chromosome ${i}: VCF decompression and stats calculation completed."

done

