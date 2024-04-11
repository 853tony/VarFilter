#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J GI_VarFilter

#SBATCH -p ngs372G

#SBATCH -c 56

#SBATCH --mem=372g

#SBATCH -o ../../log_dir/GI_VarFilter.out.log

#SBATCH -e ../../log_dir/GI_VarFilter.err.log

#SBATCH --mail-user=d12456001@g.ntu.edu.tw

#SBATCH --mail-type=ALL

module add biology/Python/3.11.0

submodule=$1
wkdir=$2
scrdir=$3
cp=$4
FC=$5
e1=$6
l1=$7
e2=$8
l2=$9
extracted=$10
shift 10

command > ../../log_dir/${submodule}_filtering.log.txt
log_file="../../log_dir/${submodule}_filtering.log.txt"
exec > "$log_file" 2>&1
echo "Filtering script started at $(date)"


process_model() {
    local params=("${@}")
    local i=0
    while [ $i -lt "${#params[@]}" ]; do
        models_val="${params[$i]}"
        p1_val="${params[$((i+1))]}"
        f1_val="${params[$((i+2))]}"
        p2_val="${params[$((i+3))]}"
        f2_val="${params[$((i+4))]}"

        if [[ "$models_val" =~ ^\".*\"$ ]]; then
            models_val=$(echo "$models_val" | tr -d '"')
        fi

        if [[ "$p1_val" =~ ^\".*\"$ ]]; then
            p1_val=$(echo "$p1_val" | tr -d '"')
        fi

        if [[ "$f1_val" =~ ^\".*\"$ ]]; then
            f1_val=$(echo "$f1_val" | tr -d '"')
        fi

        if [[ "$p2_val" =~ ^\".*\"$ ]]; then
            p2_val=$(echo "$p2_val" | tr -d '"')
        fi

        if [[ "$f2_val" =~ ^\".*\"$ ]]; then
            f2_val=$(echo "$f2_val" | tr -d '"')
        fi

        if [[ -z "$prev_models_val" ]]; then
            input_file="${wkdir}/${extracted}"
        else
            input_file="${wkdir}/${new_input}"
        fi

	echo ""
        echo "CONDITION, $models_val"
        echo "p1: ${p1_val}, f1: ${f1_val}, p2: ${p2_val}, f2: ${f2_val}"
	echo "e1: ${e1}, l1: ${l1}, e2: ${e2}, l2: ${l2}"
        echo "input_file, $input_file"
        echo ""

        start_time=$(date +%s)

        time python ${scrdir}/02_allele_freq_filtering.py \
        -FC $FC \
        -m $models_val \
        -p1 $p1_val -f1 $f1_val \
        -p2 $p2_val -f2 $f2_val \
        -cp $cp \
	-e1 $e1 -l1 $l1 \
	-e2 $e2 -l2 $l2 \
        -i ${input_file} \
        -o ${wkdir}/VarFilter_${models_val}.tsv

        end_time=$(date +%s)
        execution_time=$((end_time - start_time))
	
	echo ""
        echo "Execution time: $execution_time seconds"
        echo "output_file, ${wkdir}/VarFilter_${models_val}.tsv"
	echo ""

        new_input="VarFilter_${models_val}.tsv"

        prev_models_val=$models_val

        i=$((i+5))
    done
}

process_model "$@"

echo "Filtering script finished at $(date)"
