
## Note: step-by-step sumbit the job.

scrdir=/staging/biology/edwardch826/projects/genetic_incompatibility_MAF/VarFilter/scrs/
datadir=/staging/biology/edwardch826/biobank_genomics_data/gnomADv4.0_data/
wkdir=/staging/biology/edwardch826/projects/genetic_incompatibility_MAF/

#### Allele frequency
### extraction
### #1.module #2.submodule #3.datadir #4.wkdir #5.scrdir
#bash ${scrdir}/GI_master.sh af extraction ${datadir} ${wkdir} ${scrdir}

### #1.module #2.submodule #3.datadir #4.wkdir #5.scrdir #6.input #7.output #8.columns-keep
#bash ${scrdir}/GI_master.sh af "extraction_without_RMI-AMI-MID" ${datadir} ${wkdir} ${scrdir} MAF_METADATA_gnomadv4_exomes.tsv MAF_METADATA_ALL8_gnomadv4_exomes_v2.tsv "1-34,38-43"
#bash ${scrdir}/GI_master.sh af "extraction_without_RMI-AMI-MID" ${datadir} ${wkdir} ${scrdir} MAF_METADATA_gnomadv4_exomes.tsv MAF_METADATA_ALL7_gnomadv4_exomes_v3.tsv "1-22,26-34,38-43"

#############################################################################################

### stats # pre-analysis
### #1.module #2.submodule #3.datadir #4.wkdir #5.scrdir
#bash ${scrdir}/GI_master.sh af stats ${datadir} ${wkdir} ${scrdir}

#############################################################################################

### filtering

# Allele number VarFilter for all8
cp=AC_joint_
float_columns="AC_joint,AC_joint_XX,AC_joint_XY,AC_joint_eas,AC_joint_sas,AC_joint_mid,AC_joint_nfe,AC_joint_fin,AC_joint_afr,AC_joint_amr,AC_joint_asj"
bash ${scrdir}/GI_master.sh "filtering" "AC_all8" \
${wkdir} ${scrdir} ${cp} ${float_columns} \
"FALSE" "any" "FALSE" "any" \
"MAF_METADATA_ALL8_gnomadv4_exomes_v2.tsv" \
${wkdir}/VarFilter/misc/all8_varfilter_params.txt

# Allele number VarFilter for all7
cp=AC_joint_
float_columns="AC_joint,AC_joint_XX,AC_joint_XY,AC_joint_eas,AC_joint_sas,AC_joint_nfe,AC_joint_fin,AC_joint_afr,AC_joint_amr,AC_joint_asj"

bash ${scrdir}/GI_master.sh "filtering" "AC_all7" \
${wkdir} ${scrdir} ${cp} ${float_columns} \
"FALSE" "any" "FALSE" "any" \
"MAF_METADATA_ALL7_gnomadv4_exomes_v3.tsv" \
${wkdir}/VarFilter/misc/all7_varfilter_params.txt


### #1.module #2.submodule #3.wkdir #4.scrdir #5.col_name_prefix #6.float_columns #7.model_count
#cp=AF_joint_
#float_columns="AF_joint,AF_joint_XX,AF_joint_XY,AF_joint_eas,AF_joint_sas,AF_joint_mid,AF_joint_nfe,AF_joint_fin,AF_joint_afr,AF_joint_ami,AF_joint_amr,AF_joint_asj,AF_joint_remaining"

## A
#submodule=condA
#params=($(cat ${scrdir}/misc/af_fil_condA_params.txt))
#models=($(cat ${scrdir}/misc/af_fil_condA_models.txt))

## B
#submodule=condB
#params=($(cat ${scrdir}/misc/af_fil_condB_params.txt))
#models=($(cat ${scrdir}/misc/af_fil_condB_models.txt))

## C
#submodule=condC
#params=($(cat ${scrdir}/misc/af_fil_condC_params.txt))
#models=($(cat ${scrdir}/misc/af_fil_condC_models.txt))

## D
#submodule=condD
#params=($(cat ${scrdir}/misc/af_fil_condD_params.txt))
#models=($(cat ${scrdir}/misc/af_fil_condD_models.txt))

## cmd
#model_count=${#models[@]}
#bash ${scrdir}/GI_master.sh filtering ${submodule} ${wkdir} ${scrdir} ${cp} "${float_columns}" \
#$model_count "${params[@]}" "${models[@]}"

#############################################################################################

### stats # post-analysis
### #1.module #2.submodule #3.wkdir #4.scrdir #5.filename
#bash ${scrdir}/GI_master.sh GET stats ${wkdir} ${scrdir} MAF_METADATA_gnomadv4_exomes.tsv

##condition_A
#input_folder="${wkdir}/condition_A/"
#for file in "$input_folder"/*; do
#	if [[ $file == *.tsv ]]; then
#		filename=$(basename "$file")
#		bash ${scrdir}/GI_master.sh GET stats_condA ${wkdir} ${scrdir} ${filename}
# 	fi
#done

#condition_B
#input_folder="${wkdir}/condition_B/"
#for file in "$input_folder"/*; do
#        if [[ $file == *.tsv ]]; then
#                filename=$(basename "$file")
#		bash ${scrdir}/GI_master.sh GET stats_condB ${wkdir} ${scrdir} ${filename}
#	fi
#done

#condition_C
#input_folder="${wkdir}/condition_C/"
#for file in "$input_folder"/*; do
#        if [[ $file == *.tsv ]]; then
#               filename=$(basename "$file")
#		bash ${scrdir}/GI_master.sh GET stats_condC ${wkdir} ${scrdir} ${filename}
#	fi
#done

#condition_D
#input_folder="${wkdir}/condition_D/"
#for file in "$input_folder"/*; do
#        if [[ $file == *.tsv ]]; then
#                filename=$(basename "$file")
#                bash ${scrdir}/GI_master.sh GET stats_condD ${wkdir} ${scrdir} ${filename}
#        fi
#done

#############################################################################################

### 2ndfiltering
### #1.module #2.submodule #3.wkdir #4.scrdir #5.col_name_prefix #6.float_columns #7.model_count
## afFILnz
#cp=AN_joint_
#float_columns="AN_joint,AN_joint_XX,AN_joint_XY,AN_joint_eas,AN_joint_sas,AN_joint_mid,AN_joint_nfe,AN_joint_fin,AN_joint_afr,AN_joint_ami,AN_joint_amr,AN_joint_asj,AN_joint_remaining"
#params=("eas,sas,mid,nfe,fin,afr,ami,amr,asj,remaining" "0" "none" "999")
#models=("afFILnz")
#model_count=${#models[@]}

## cmd
#condition_A
#submodule=nz_condA
#input_folder="${wkdir}/condition_A/"
#for file in "$input_folder"/*; do
#	if [[ $file == *.tsv ]]; then
#		filename=$(basename "$file")
#		bash ${scrdir}/GI_master.sh 2ndfiltering ${submodule} ${wkdir} ${scrdir} ${cp} "${float_columns}" \
#$model_count ${filename} "${params[@]}" "${models[@]}"
#	fi
#done

#condition_B
#submodule=nz_condB
#input_folder="${wkdir}/condition_B/"
#for file in "$input_folder"/*; do
#        if [[ $file == *.tsv ]]; then
#                filename=$(basename "$file")
#                bash ${scrdir}/GI_master.sh 2ndfiltering ${submodule} ${wkdir} ${scrdir} ${cp} "${float_columns}" \
#$model_count ${filename} "${params[@]}" "${models[@]}"
#        fi
#done

#condition_C
#submodule=nz_condC
#input_folder="${wkdir}/condition_C/"
#for file in "$input_folder"/*; do
#        if [[ $file == *.tsv ]]; then
#                filename=$(basename "$file")
#                bash ${scrdir}/GI_master.sh 2ndfiltering ${submodule} ${wkdir} ${scrdir} ${cp} "${float_columns}" \
#$model_count ${filename} "${params[@]}" "${models[@]}"
#        fi
#done

#condition_D
#submodule=nz_condD
#input_folder="${wkdir}/condition_D/"
#for file in "$input_folder"/*; do
#        if [[ $file == *.tsv ]]; then
#                filename=$(basename "$file")
#                bash ${scrdir}/GI_master.sh 2ndfiltering ${submodule} ${wkdir} ${scrdir} ${cp} "${float_columns}" \
#$model_count ${filename} "${params[@]}" "${models[@]}"
#        fi
#done

#############################################################################################

### 2ndstats # post-analysis
### #1.module #2.submodule #3.wkdir #4.scrdir #5.filename

#condition_A
#input_folder="${wkdir}/condition_A_nz/"
#for file in "$input_folder"/*; do
#       if [[ $file == *.tsv ]]; then
#               filename=$(basename "$file")
#               bash ${scrdir}/GI_master.sh 2ndGET stats_condA ${wkdir} ${scrdir} ${filename}
#       fi
#done

#condition_B
#input_folder="${wkdir}/condition_B_nz/"
#for file in "$input_folder"/*; do
#        if [[ $file == *.tsv ]]; then
#                filename=$(basename "$file")
#               bash ${scrdir}/GI_master.sh 2ndGET stats_condB ${wkdir} ${scrdir} ${filename}
#       fi
#done

#condition_C
#input_folder="${wkdir}/condition_C_nz/"
#for file in "$input_folder"/*; do
#        if [[ $file == *.tsv ]]; then
#               filename=$(basename "$file")
#              bash ${scrdir}/GI_master.sh 2ndGET stats_condC ${wkdir} ${scrdir} ${filename}
#       fi
#done

#condition_D
#input_folder="${wkdir}/condition_D_nz/"
#for file in "$input_folder"/*; do
#        if [[ $file == *.tsv ]]; then
#                filename=$(basename "$file")
#                bash ${scrdir}/GI_master.sh 2ndGET stats_condD ${wkdir} ${scrdir} ${filename}
#        fi
#done


