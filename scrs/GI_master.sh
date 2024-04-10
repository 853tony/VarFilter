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
	l2=$10
        extracted=$11 #input_tsv_file
        inp=$12 #input_params_file

#****************************************************************#
#               all8/all7-any allele count > 0                   #
#****************************************************************#

	if [ $submodule == "AC_all8" ]; then
		declare -a ALL8_ACnz

		while IFS= read -r line; do
			params=($line)
			case "${params[0]}" in
			"\"ALL8_ACnz\"")
				ALL8_ACnz+=("${params[1]}" "${params[2]}" "${params[3]}" "${params[4]}" "${params[5]}")	
			esac
		done < "$inp"

		for cond in ALL8_ACnz; do

			case $cond in
			ALL8_ACnz)
				if [ ${#ALL8_ACnz[@]} -ne 0 ]; then
					echo "codition: ${ALL8_ACnz[@]}"
					sbatch "${scrdir}/02_allele_freq_filtering.sh" "${submodule}" "${wkdir}" "${scrdir}" "${cp}" "${FC}" ${e1} ${l1} ${e2} ${l2} "${extracted}" "${ALL8_ACnz[@]}"
				else
					echo "Warning: $cond is empty. Skipping execution for $cond."
				fi
			esac
		done
	fi


	if [ $submodule == "AC_all7" ]; then
		declare -a ALL7_ACnz

		while IFS= read -r line; do
			params=($line)
			case "${params[0]}" in
			"\"ALL7_ACnz\"")
				ALL7_ACnz+=("${params[1]}" "${params[2]}" "${params[3]}" "${params[4]}" "${params[5]}")
			esac
		done < "$inp"

		for cond in ALL7_ACnz; do

			case $cond in
			ALL7_ACnz)
				if [ ${#ALL7_ACnz[@]} -ne 0 ]; then
					echo "codition: ${ALL7_ACnz[@]}"
					sbatch "${scrdir}/02_allele_freq_filtering.sh" "${submodule}" "${wkdir}" "${scrdir}" "${cp}" "${FC}" ${e1} ${l1} ${e2} ${l2} "${extracted}" "${ALL7_ACnz[@]}"
				else
					 echo "Warning: $cond is empty. Skipping execution for $cond."
				fi
			esac
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

