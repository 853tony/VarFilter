#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J genetic_incompatibility_GET

#SBATCH -p ngs372G

#SBATCH -c 56

#SBATCH --mem=372g

#SBATCH -o ./LOG/genetic_incompatibility_GET.out.log

#SBATCH -e ./LOG/genetic_incompatibility_GET.err.log

#SBATCH --mail-user=d12456001@g.ntu.edu.tw    # email

#SBATCH --mail-type=ALL

#!/bin/bash

module add biology/Python/3.11.0
current_time=$(date +"%Y%m%d%S")

wkdir=$1
scrdir=$2
file=$3
input=${wkdir}/${file}
output=$(basename $input .tsv)

echo "script from ${scrdir}"
echo "output to ${wkdir}/stats/"
python ${scrdir}/03_GET.py -i ${input} -o ${wkdir}/stats/${output} -CS

cp ./LOG/genetic_incompatibility_GET.out.log ./LOG/genetic_incompatibility_GET.${current_time}.out.log
cp ./LOG/genetic_incompatibility_GET.err.log ./LOG/genetic_incompatibility_GET.${current_time}.err.log

