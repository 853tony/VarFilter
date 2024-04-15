#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J GET_modelA/B

#SBATCH -p ngs13G

#SBATCH -c 2

#SBATCH --mem=13g

#SBATCH -o ../../log_dir/GET_ModelAorB.out.log

#SBATCH -e ../../log_dir/GET_ModelAorB.err.log

#SBATCH --mail-user=d12456001@g.ntu.edu.tw    # email

#SBATCH --mail-type=ALL

#!/bin/bash

module add biology/Python/3.11.0
submodule=$1
wkdir=$2
scrdir=$3
file=$4
input=${wkdir}/${submodule}/${file}
output_name=$(basename $input .tsv)
output_dir=${wkdir}/stats/${submodule}
mkdir -p ${output_dir}

echo "script from ${scrdir}"
echo "output to ${output_dir}"
python ${scrdir}/03_GET.py -i ${input} -o ${output_dir}/${output_name} -CS


