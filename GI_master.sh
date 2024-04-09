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
	model_count=$7
	shift 7
	
	params=("$@:1:$((${#@} - $model_count))")
	models=("${@:${#@} - $model_count + 1:$model_count}")

#***************************************#
#		codition A		#
#***************************************#

	if [ $submodule == "condA" ]; then
		sbatch ${scrdir}/02_allele_freq_filtering_A.sh ${wkdir} ${scrdir} ${cp} ${FC} ${model_count} "${params[@]}" "${models[@]}"
	fi

#***************************************#
#               codition B              #
#***************************************#

	if [ $submodule == "condB" ]; then
		sbatch ${scrdir}/02_allele_freq_filtering_B.sh ${wkdir} ${scrdir} ${cp} ${FC} ${model_count} "${params[@]}" "${models[@]}"
	fi

#***************************************#
#               codition C              #
#***************************************#

	if [ $submodule == "condC" ]; then
		sbatch ${scrdir}/02_allele_freq_filtering_C.sh ${wkdir} ${scrdir} ${cp} ${FC} ${model_count} "${params[@]}" "${models[@]}"
	fi

#***************************************#
#               codition D              #
#***************************************#

	if [ $submodule == "condD" ]; then
		sbatch ${scrdir}/02_allele_freq_filtering_D.sh ${wkdir} ${scrdir} ${cp} ${FC} ${model_count} "${params[@]}" "${models[@]}"
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

