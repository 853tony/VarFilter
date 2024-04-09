#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J genetic_incompatibility_MAF

#SBATCH -p ngs372G

#SBATCH -c 56

#SBATCH --mem=372g

#SBATCH -o ./LOG/genetic_incompatibility_MAF.out.log

#SBATCH -e ./LOG/genetic_incompatibility_MAF.err.log

#SBATCH --mail-user=d12456001@g.ntu.edu.tw

#SBATCH --mail-type=ALL

module add biology/Python/3.11.0

datadir=$1
wkdir=$2
scrdir=$3

python ${scrdir}/01_allele_freq_extraction.py ${datadir} ${wkdir}

