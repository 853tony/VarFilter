#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J GI_MAF

#SBATCH -p ngs372G

#SBATCH -c 56

#SBATCH --mem=372g

#SBATCH -o ../../log_gnomadv4.0.0_dir/GI_gnomadv2.out.log

#SBATCH -e ../../log_gnomadv4.0.0_dir/GI_gnomadv2.err.log

#SBATCH --mail-user=d12456001@g.ntu.edu.tw

#SBATCH --mail-type=ALL

module add biology/Python/3.11.0

datadir=$1
wkdir=$2
scrdir=$3

python ${scrdir}/01_allele_freq_extractionv2.py ${datadir} ${wkdir}

