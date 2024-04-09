#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J genetic_incompatibility_MAF_fil_D

#SBATCH -p ngs372G

#SBATCH -c 56

#SBATCH --mem=372g

#SBATCH -o ./LOG/genetic_incompatibility_MAF_fil_D.out.log

#SBATCH -e ./LOG/genetic_incompatibility_MAF_fil_D.err.log

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

outpdir=condition_D
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

    p1_val="${params[$p1_idx]}"
    if [[ "$p1_val" =~ ^\".*\"$ ]]; then
        p1_val=$(echo "$p1_val" | tr -d '"')
    fi

    f1_val="${params[$f1_idx]}"
    if [[ "$f1_val" =~ ^\".*\"$ ]]; then
        f1_val=$(echo "$f1_val" | tr -d '"')
    fi

    p2_val="${params[$p2_idx]}"
    if [[ "$p2_val" =~ ^\".*\"$ ]]; then
        p2_val=$(echo "$p2_val" | tr -d '"')
    fi

    f2_val="${params[$f2_idx]}"
    if [[ "$f2_val" =~ ^\".*\"$ ]]; then
        f2_val=$(echo "$f2_val" | tr -d '"')
    fi

    models_val="${models[$i]}"
    if [[ "$models_val" =~ ^\".*\"$ ]]; then
        models_val=$(echo "$models_val" | tr -d '"')
    fi

time python ${scrdir}/02_allele_freq_filtering.py \
-FC $FC \
-m $models_val \
-p1 $p1_val -f1 $f1_val \
-p2 $p2_val -f2 $f2_val \
-cp $cp -i ${wkdir}/MAF_METADATA_gnomadv4_exomes.tsv \
-o ${wkdir}/${outpdir}/MAF_${outpdir}_${models_val}_gnomadv4_exomes.tsv

done
