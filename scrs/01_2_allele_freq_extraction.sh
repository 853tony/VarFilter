#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J extraction_rm_col

#SBATCH -p ngs372G

#SBATCH -c 56

#SBATCH --mem=372g

#SBATCH -o ../../log_dir/extraction_rm_col.out.log

#SBATCH -e ../../log_dir/extraction_rm_col.err.log

#SBATCH --mail-user=d12456001@g.ntu.edu.tw

#SBATCH --mail-type=ALL

wkdir=$1
inp=$2
outp=$3
cols=$4

name=$(basename $outp .tsv)

command > ../../log_dir/${name}.log.txt
log_file="../../log_dir/${name}.log.txt"
exec > "$log_file" 2>&1
echo "${name} script started at $(date)"

cut -f ${cols} ${wkdir}/${inp} > ${wkdir}/${outp}

echo "${name} script finished at $(date)"

