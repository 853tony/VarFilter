#/bin/bash

module=$1

#*******************************************************#
#			Module: af			#
#*******************************************************#

if [ $module == "af" ]; then
	
	submodule=$2
	datadir=$3
	wkdir=$4	#outputdir
	scrdir=$5	#scriptsdir

#***************************************#
#		stats			#
#***************************************#

	if [ $submodule == "stats" ]; then
		sbatch ${scrdir}/00_vcf_information.sh ${datadir} ${wkdir} ${scrdir}
	fi

#***********************************************#
#		Data extraction			#
#***********************************************#

	if [ $submodule == "extraction" ]; then
		sbatch ${scrdir}/01_allele_freq_extraction.sh ${datadir} ${wkdir} ${scrdir}
	fi

	if [ $submodule == "extraction_without_RMI-AMI-MID" ]; then
		extracted=$6
		outp=$7
		cols=$8
                sbatch ${scrdir}/01_2_allele_freq_extraction.sh ${wkdir} ${extracted} ${outp} ${cols}
	fi

fi

#**************************************************************#
#                       Module: filtering                      #
#**************************************************************#

if [ $module == "filtering" ]; then

	submodule=$2
	wkdir=$3
	scrdir=$4
	cp=$5
	FC=$6
	e1=$7
	l1=$8
	e2=$9
	l2=${10}
        extracted=${11} #input_tsv_file
        inp=${12} #input_params_file

# Function definition: Submit Job
function submit_job {
    local var_name=$1
    local var_array=("${!2}")  # Use name reference to indirectly access arrays
    if [ ${#var_array[@]} -ne 0 ]; then
        echo "Condition: ${var_array[@]}"

sbatch "${scrdir}/02_allele_freq_filtering.sh" "${submodule}" "${wkdir}" "${scrdir}" \
"${cp}" "${FC}" \
"${e1}" "${l1}" "${e2}" "${l2}" \
"${extracted}" \
"${var_array[@]}"

    else
        echo "Warning: $var_name is empty. Skipping execution for $var_name."
    fi
}

# Function definition: Parse and Fill Arrays
function parse_and_fill_arrays {
    local inp_file=$1
    shift  # Remove the first argument (file name), the rest are array names
    declare -A array_map=()  # Associative array, mapping identifiers to array names

    # Dynamically build associative array mapping
    for array_name in "$@"; do
        array_map["\"$array_name\""]=$array_name
    done

    echo "Starting to read from input file: $inp_file"

    while IFS= read -r line; do
        echo "Reading line: $line"
        IFS=' ' read -ra params <<< "$line"  # Temporarily change IFS to space to parse line
        echo "Params read: ${params[@]}"
        echo ""

        local identifier=${params[0]}
        local target_array=${array_map[$identifier]}

        if [[ -n "$target_array" ]]; then
            echo "Adding to $target_array: ${params[@]:1}"
            echo ""

            eval "$target_array+=(\"\${params[@]:1}\")"  # Dynamically add elements
        fi
    done < "$inp_file"
}

#****************************************************************#
#               all8/all7-any allele count > 0                   #
#****************************************************************#

if [ "$submodule" == "ALL8_ACnz" ]; then
    declare -a ${submodule}

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp}" "${submodule}"

    # Iterate over all arrays and attempt to submit jobs
    for var in ${submodule}; do
        submit_job "$var" "${var}[@]"
    done
fi

if [ "$submodule" == "ALL7_ACnz" ]; then
    declare -a ${submodule}

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp}" "${submodule}"

    # Iterate over all arrays and attempt to submit jobs
    for var in ${submodule}; do
        submit_job "$var" "${var}[@]"
    done
fi  

fi



#********************************************************#
#                       Module: GET                      #
#********************************************************#

if [ $module == "GET" ]; then

        submodule=$2
	wkdir=$3       #outputdir
	scrdir=$4       #scriptsdir
	file=$5

#***************************************#
#               stats                   #
#***************************************#

        if [ $submodule == "stats" ]; then
                sbatch ${scrdir}/03_GET.sh ${wkdir} ${scrdir} ${file}
        fi

	if [ $submodule == "stats_condA" ]; then
                sbatch ${scrdir}/03_GET_condA.sh ${wkdir} ${scrdir} ${file}
        fi

	if [ $submodule == "stats_condB" ]; then
                sbatch ${scrdir}/03_GET_condB.sh ${wkdir} ${scrdir} ${file}
        fi

	if [ $submodule == "stats_condC" ]; then
                sbatch ${scrdir}/03_GET_condC.sh ${wkdir} ${scrdir} ${file}
        fi

	if [ $submodule == "stats_condD" ]; then
                sbatch ${scrdir}/03_GET_condD.sh ${wkdir} ${scrdir} ${file}
        fi
fi

#**************************************************************#
#                       Module: 2ndfiltering                   #
#**************************************************************#

if [ $module == "2ndfiltering" ]; then

        submodule=$2
        wkdir=$3
        scrdir=$4
        cp=$5
        FC=$6
        model_count=$7
	filename=$8
        shift 8

        params=("$@:1:$((${#@} - $model_count))")
        models=("${@:${#@} - $model_count + 1:$model_count}")

#*********************************************#
#               codition afFILnz              #
#*********************************************#

        if [ $submodule == "nz_condA" ]; then
                sbatch ${scrdir}/02_allele_freq_filtering_nzcondA.sh ${wkdir} ${scrdir} ${cp} ${FC} ${model_count} ${filename} "${params[@]}" "${models[@]}"
        fi

        if [ $submodule == "nz_condB" ]; then
                sbatch ${scrdir}/02_allele_freq_filtering_nzcondB.sh ${wkdir} ${scrdir} ${cp} ${FC} ${model_count} ${filename} "${params[@]}" "${models[@]}"
        fi

        if [ $submodule == "nz_condC" ]; then
                sbatch ${scrdir}/02_allele_freq_filtering_nzcondC.sh ${wkdir} ${scrdir} ${cp} ${FC} ${model_count} ${filename} "${params[@]}" "${models[@]}"
        fi

        if [ $submodule == "nz_condD" ]; then
                sbatch ${scrdir}/02_allele_freq_filtering_nzcondD.sh ${wkdir} ${scrdir} ${cp} ${FC} ${model_count} ${filename} "${params[@]}" "${models[@]}"
        fi
fi

#***********************************************************#
#                       Module: 2ndGET                      #
#***********************************************************#

if [ $module == "2ndGET" ]; then

        submodule=$2
        wkdir=$3       #outputdir
        scrdir=$4       #scriptsdir
        file=$5

#***************************************#
#               stats                   #
#***************************************#

        if [ $submodule == "stats_condA" ]; then
                sbatch ${scrdir}/03_GET_nzcondA.sh ${wkdir} ${scrdir} ${file}
        fi

        if [ $submodule == "stats_condB" ]; then
                sbatch ${scrdir}/03_GET_nzcondB.sh ${wkdir} ${scrdir} ${file}
        fi

        if [ $submodule == "stats_condC" ]; then
                sbatch ${scrdir}/03_GET_nzcondC.sh ${wkdir} ${scrdir} ${file}
        fi

        if [ $submodule == "stats_condD" ]; then
                sbatch ${scrdir}/03_GET_nzcondD.sh ${wkdir} ${scrdir} ${file}
        fi
fi

