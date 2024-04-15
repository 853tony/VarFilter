#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J GET_post_analysis

#SBATCH -p ngs186G

#SBATCH -c 28

#SBATCH --mem=186g

#SBATCH -o ../../log_dir/GET_post_analysis.out.log

#SBATCH -e ../../log_dir/GET_post_analysis.err.log

#SBATCH --mail-user=d12456001@g.ntu.edu.tw    # email

#SBATCH --mail-type=ALL

#!/bin/bash

module add biology/Python/3.11.0
submodule=$1
wkdir=$2
scrdir=$3
file=$4
input=${wkdir}/${file}
output_name=$(basename $input .tsv)
output_dir=${wkdir}/stats/${submodule}
mkdir -p ${output_dir}

echo "script from ${scrdir}"
echo "output to ${output_dir}"
python ${scrdir}/03_GET.py -i ${input} -o ${output_dir}/${output_name} -CS


