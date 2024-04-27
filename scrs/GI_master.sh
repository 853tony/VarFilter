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

	if [ $submodule == "extraction_rm_col" ]; then
		extracted=$6
		outp=$7
		cols=$8
                sbatch ${scrdir}/01_2_allele_freq_extraction.sh ${wkdir} ${extracted} ${outp} ${cols}
	fi

fi #dont del me

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
        inp_pretsv=${11} #input_tsv_file
        inp_params=${12} #input_params_file

# Function definition: Submit Job
function submit_job {
    local var_name=$1
    local var_array=("${!2}")  # Use name reference to indirectly access arrays
    if [ ${#var_array[@]} -ne 0 ]; then
        echo "Condition: ${var_array[@]}"

sbatch "${scrdir}/02_allele_freq_filtering.sh" "${submodule}" "${wkdir}" "${scrdir}" \
"${cp}" "${FC}" \
"${e1}" "${l1}" "${e2}" "${l2}" \
"${inp_pretsv}" \
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

#***********************************************************#
#               01. all10 allele count QC                   #
#***********************************************************#

if [ "$submodule" == "ALL10_ACqc" ]; then
    declare -a ${submodule}

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${submodule}"

    # Iterate over all arrays and attempt to submit jobs
    for var in ${submodule}; do
        submit_job "$var" "${var}[@]"
    done
fi

if [ "$submodule" == "ALL10_ACeq0" ]; then
    declare -a ${submodule}

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${submodule}"

    # Iterate over all arrays and attempt to submit jobs
    for var in ${submodule}; do
        submit_job "$var" "${var}[@]"
    done
fi

#***************************************************************#
#		02a. ModelA allele count QC			#
#***************************************************************#

if [ "$submodule" == "ModelA_ALL8_ACqc" ]; then
    declare -a ${submodule}

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${submodule}"

    # Iterate over all arrays and attempt to submit jobs
    for var in ${submodule}; do
        submit_job "$var" "${var}[@]"
    done
fi

if [ "$submodule" == "ModelA_ALL8_ACeq0" ]; then
    declare -a ${submodule}

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${submodule}"

    # Iterate over all arrays and attempt to submit jobs
    for var in ${submodule}; do
        submit_job "$var" "${var}[@]"
    done
fi

#***************************************************************#
#		02b. ModelB allele count QC			#
#***************************************************************#

if [ "$submodule" == "ModelB_ALL7_ACqc" ]; then
    declare -a ${submodule}

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${submodule}"

    # Iterate over all arrays and attempt to submit jobs
    for var in ${submodule}; do
        submit_job "$var" "${var}[@]"
    done
fi

if [ "$submodule" == "ModelB_ALL7_ACeq0" ]; then
    declare -a ${submodule}

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${submodule}"

    # Iterate over all arrays and attempt to submit jobs
    for var in ${submodule}; do
        submit_job "$var" "${var}[@]"
    done
fi

#**************************************************************#
#               03a. ModelA allele number QC                   #
#**************************************************************#

if [ "$submodule" == "ModelA_ALL8_ACqcANqc" ]; then
    declare -a ${submodule}

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${submodule}"

    # Iterate over all arrays and attempt to submit jobs
    for var in ${submodule}; do
        submit_job "$var" "${var}[@]"
    done
fi

if [ "$submodule" == "ModelA_ALL8_ACqcANeq0" ]; then
    declare -a ${submodule}

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${submodule}"

    # Iterate over all arrays and attempt to submit jobs
    for var in ${submodule}; do
        submit_job "$var" "${var}[@]"
    done
fi

#**************************************************************#
#               03b. ModelB allele number QC                   #
#**************************************************************#

if [ "$submodule" == "ModelB_ALL7_ACqcANqc" ]; then
    declare -a ${submodule}

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${submodule}"

    # Iterate over all arrays and attempt to submit jobs
    for var in ${submodule}; do
        submit_job "$var" "${var}[@]"
    done
fi

if [ "$submodule" == "ModelB_ALL7_ACqcANeq0" ]; then
    declare -a ${submodule}

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${submodule}"

    # Iterate over all arrays and attempt to submit jobs
    for var in ${submodule}; do
        submit_job "$var" "${var}[@]"
    done
fi

#***********************************************#
#		04. Call rate QC		#
#***********************************************#

if [ "$submodule" == "ModelA_ALL8_ACqcANqcCRqc" ]; then
declare -a model_identifiers=(ModelA_ALL8_ACqcANqcCR10qc ModelA_ALL8_ACqcANqcCR20qc ModelA_ALL8_ACqcANqcCR30qc ModelA_ALL8_ACqcANqcCR40qc)

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${model_identifiers[@]}"

    # Iterate over all arrays and attempt to submit jobs
    for var in "${model_identifiers[@]}"; do
        submit_job "$var" "${var}[@]"
    done
fi

if [ "$submodule" == "ModelB_ALL7_ACqcANqcCRqc" ]; then
declare -a model_identifiers=(ModelB_ALL7_ACqcANqcCR10qc ModelA_ALL8_ACqcANqcCR20qc ModelA_ALL8_ACqcANqcCR30qc ModelA_ALL8_ACqcANqcCR40qc)

    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${model_identifiers[@]}"

    # Iterate over all arrays and attempt to submit jobs
    for var in "${model_identifiers[@]}"; do
        submit_job "$var" "${var}[@]"
    done
fi

#**************************************************************************************************#
#               05. ModelA/B spcific ancestry allele frequency filtering	                   #
#**************************************************************************************************#

if [ "$submodule" == "ModelA_ALL8_SpeAncVarFil" ]; then
declare -a model_identifiers=(
    ModelA_EAS_C1 ModelA_EAS_C5 ModelA_EAS_C10 ModelA_EAS_C20 ModelA_EAS_R05 ModelA_EAS_R01 ModelA_EAS_R005 ModelA_EAS_R001
    ModelA_SAS_C1 ModelA_SAS_C5 ModelA_SAS_C10 ModelA_SAS_C20 ModelA_SAS_R05 ModelA_SAS_R01 ModelA_SAS_R005 ModelA_SAS_R001
    ModelA_FIN_C1 ModelA_FIN_C5 ModelA_FIN_C10 ModelA_FIN_C20 ModelA_FIN_R05 ModelA_FIN_R01 ModelA_FIN_R005 ModelA_FIN_R001
    ModelA_NFE_C1 ModelA_NFE_C5 ModelA_NFE_C10 ModelA_NFE_C20 ModelA_NFE_R05 ModelA_NFE_R01 ModelA_NFE_R005 ModelA_NFE_R001
    ModelA_AFR_C1 ModelA_AFR_C5 ModelA_AFR_C10 ModelA_AFR_C20 ModelA_AFR_R05 ModelA_AFR_R01 ModelA_AFR_R005 ModelA_AFR_R001
    ModelA_AMR_C1 ModelA_AMR_C5 ModelA_AMR_C10 ModelA_AMR_C20 ModelA_AMR_R05 ModelA_AMR_R01 ModelA_AMR_R005 ModelA_AMR_R001
    ModelA_ASJ_C1 ModelA_ASJ_C5 ModelA_ASJ_C10 ModelA_ASJ_C20 ModelA_ASJ_R05 ModelA_ASJ_R01 ModelA_ASJ_R005 ModelA_ASJ_R001
    ModelA_MID_C1 ModelA_MID_C5 ModelA_MID_C10 ModelA_MID_C20 ModelA_MID_R05 ModelA_MID_R01 ModelA_MID_R005 ModelA_MID_R001
)
    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${model_identifiers[@]}"

    # Iterate over all arrays and attempt to submit jobs
    for var in "${model_identifiers[@]}"; do
        submit_job "$var" "${var}[@]"
    done
fi

if [ "$submodule" == "ModelB_ALL7_SpeAncVarFil" ]; then
declare -a model_identifiers=(
    ModelB_EAS_C1 ModelB_EAS_C5 ModelB_EAS_C10 ModelB_EAS_C20 ModelB_EAS_R05 ModelB_EAS_R01 ModelB_EAS_R005 ModelB_EAS_R001
    ModelB_SAS_C1 ModelB_SAS_C5 ModelB_SAS_C10 ModelB_SAS_C20 ModelB_SAS_R05 ModelB_SAS_R01 ModelB_SAS_R005 ModelB_SAS_R001
    ModelB_FIN_C1 ModelB_FIN_C5 ModelB_FIN_C10 ModelB_FIN_C20 ModelB_FIN_R05 ModelB_FIN_R01 ModelB_FIN_R005 ModelB_FIN_R001
    ModelB_NFE_C1 ModelB_NFE_C5 ModelB_NFE_C10 ModelB_NFE_C20 ModelB_NFE_R05 ModelB_NFE_R01 ModelB_NFE_R005 ModelB_NFE_R001
    ModelB_AFR_C1 ModelB_AFR_C5 ModelB_AFR_C10 ModelB_AFR_C20 ModelB_AFR_R05 ModelB_AFR_R01 ModelB_AFR_R005 ModelB_AFR_R001
    ModelB_AMR_C1 ModelB_AMR_C5 ModelB_AMR_C10 ModelB_AMR_C20 ModelB_AMR_R05 ModelB_AMR_R01 ModelB_AMR_R005 ModelB_AMR_R001
    ModelB_ASJ_C1 ModelB_ASJ_C5 ModelB_ASJ_C10 ModelB_ASJ_C20 ModelB_ASJ_R05 ModelB_ASJ_R01 ModelB_ASJ_R005 ModelB_ASJ_R001

)
    # Use the function to populate arrays
    parse_and_fill_arrays "${inp_params}" "${model_identifiers[@]}"

    # Iterate over all arrays and attempt to submit jobs
    for var in "${model_identifiers[@]}"; do
        submit_job "$var" "${var}[@]"
    done
fi

fi #dont del me
#********************************************************#
#                       Module: GET                      #
#********************************************************#

if [ $module == "GET" ]; then

        submodule=$2
	wkdir=$3	#outputdir
	scrdir=$4       #scriptsdir
	inputdir=$5	#inputdir
	file=$6

#***************************************#
#               stats                   #
#***************************************#

        if [ $submodule == "post_analysis" ]; then
                sbatch ${scrdir}/03_GET.sh ${submodule} ${wkdir} ${scrdir} ${inputdir} ${file}
        fi

        if [ $submodule == "CRQC_post_analysis" ]; then
                sbatch ${scrdir}/03_GET.sh ${submodule} ${wkdir} ${scrdir} ${inputdir} ${file}
        fi

	if [ $submodule == "ModelA" ]; then
                sbatch ${scrdir}/03_GET.sh ${submodule} ${wkdir} ${scrdir} ${inputdir} ${file}
        fi

        if [ $submodule == "ModelA_CR" ]; then
                sbatch ${scrdir}/03_GET.sh ${submodule} ${wkdir} ${scrdir} ${inputdir} ${file}
        fi

        if [ $submodule == "ModelB" ]; then
                sbatch ${scrdir}/03_GET.sh ${submodule} ${wkdir} ${scrdir} ${inputdir} ${file}
        fi

        if [ $submodule == "ModelB_CR" ]; then
                sbatch ${scrdir}/03_GET.sh ${submodule} ${wkdir} ${scrdir} ${inputdir} ${file}
        fi

fi #dont del me
