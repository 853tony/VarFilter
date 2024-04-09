#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J GET_nzcondC

#SBATCH -p ngs372G

#SBATCH -c 56

#SBATCH --mem=372g

#SBATCH -o ./LOG/genetic_incompatibility_GET_nzcondC.out.log

#SBATCH -e ./LOG/genetic_incompatibility_GET_nzcondC.err.log

#SBATCH --mail-user=d12456001@g.ntu.edu.tw    # email

#SBATCH --mail-type=ALL

#!/bin/bash

module add biology/Python/3.11.0
#wkdir=/staging/biology/edwardch826/projects/genetic_incompatibility_MAF/
wkdir=$1
scrdir=$2
file=$3
input=${wkdir}/condition_C_nz/${file}
output=$(basename $input .tsv)

echo "script from ${scrdir}"
echo "output to ${wkdir}/stats/"
python ${scrdir}/03_GET.py -i ${input} -o ${wkdir}/stats/${output} -CS

cp ./LOG/genetic_incompatibility_GET_nzcondC.out.log ./LOG/genetic_incompatibility_GET_nzcondC.${output}.out.log
cp ./LOG/genetic_incompatibility_GET_nzcondC.err.log ./LOG/genetic_incompatibility_GET_nzcondC.${output}.err.log

