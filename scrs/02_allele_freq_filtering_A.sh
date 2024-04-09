#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J genetic_incompatibility_MAF_fil_A

#SBATCH -p ngs372G

#SBATCH -c 56

#SBATCH --mem=372g

#SBATCH -o ./LOG/genetic_incompatibility_MAF_fil_A.out.log

#SBATCH -e ./LOG/genetic_incompatibility_MAF_fil_A.err.log

#SBATCH --mail-user=d12456001@g.ntu.edu.tw

#SBATCH --mail-type=ALL

module add biology/Python/3.11.0

wkdir=$1
scrdir=$2
cp=$3
FC=$4
model_count=$5
shift 5
params=("$@:1:$((${#@} - $model_count))")
models=("${@:${#@} - $model_count + 1:$model_count}")

outpdir=condition_A
mkdir -p ${wkdir}/${outpdir}
echo "script from ${scrdir}"
echo "output to ${wkdir}/${outpdir}"
#python ${scrdir}/02_allele_freq_filtering.py -FC -m -p1  -f1  -p2  -f2  -cp -i  -o

for i in "${!models[@]}"; do
    j=$((4 * $i))
    p1_idx=$((0 + $j))
    f1_idx=$((1 + $j))
    p2_idx=$((2 + $j))
    f2_idx=$((3 + $j))

time python ${scrdir}/02_allele_freq_filtering.py \
-FC $FC \
-m ${models[$i]} \
-p1 ${params[$p1_idx]} -f1 ${params[$f1_idx]%\%} \
-p2 ${params[$p2_idx]} -f2 ${params[$f2_idx]%\%} \
-cp $cp -i ${wkdir}/MAF_METADATA_gnomadv4_exomes.tsv \
-o ${wkdir}/${outpdir}/MAF_${outpdir}_${models[$i]}_gnomadv4_exomes.tsv

done
