#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J GET

#SBATCH -p ngs26G

#SBATCH -c 4

#SBATCH --mem=26g

#SBATCH -o ../../log_dir/GET.out.log

#SBATCH -e ../../log_dir/GET.err.log

#SBATCH --mail-user=d12456001@g.ntu.edu.tw    # email

#SBATCH --mail-type=ALL

#!/bin/bash

module add biology/Python/3.11.0
submodule=$1
wkdir=$2
scrdir=$3
inputdir=$4
file=$5
input=${inputdir}/${file}
output_name=$(basename $input .tsv)
output_dir=${wkdir}/stats/${submodule}
mkdir -p ${output_dir}

echo "script from ${scrdir}"
echo "output to ${output_dir}"
python ${scrdir}/03_GET.py -i ${input} -o ${output_dir}/${output_name} -CS


