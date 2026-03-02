## Note: step-by-step sumbit the job.

scrdir=/staging/biology/edwardch826/projects/genetic_incompatibility_MAF/VarFilter/scrs/

miscdir=/staging/biology/edwardch826/projects/genetic_incompatibility_MAF/VarFilter/misc/

datadir=/staging/biology/edwardch826/utility/gnomADv2.1.1_data/

wkdir=/staging/biology/edwardch826/projects/genetic_incompatibility_MAF/gnomadv2.1.1/

#############################################################################################
### extraction gnomadv2.1.1
### #1.module #2.submodule #3.datadir #4.wkdir #5.scrdir
bash ${scrdir}/GI_master.sh af extractionv2 ${datadir} ${wkdir} ${scrdir}

#############################################################################################
### stats # pre-analysis
## #1.module #2.submodule #3.datadir #4.wkdir #5.scrdir

bash ${scrdir}/GI_master.sh af statsv2 ${datadir} ${wkdir} ${scrdir}

#############################################################################################
### filtering
## #1.module #2.submodule #3.wkdir #4.scrdir #5.target_column_prefix #6.float_columns_list
## #7.equal_for_cond1 #8.all/any_for_cond1 #9.equal_for_cond2 #10.all/any_for_cond2
## #11.input_file_prefix #12.input_params_file_name

##################################
## general params
AC_cp=AC_
AN_cp=AN_
AF_cp=AF_
all7_AC_fc="AC,AC_female,AC_male,AC_eas,AC_sas,AC_nfe,AC_fin,AC_afr,AC_amr,AC_asj"
all7_AN_fc="AN,AN_female,AN_male,AN_eas,AN_sas,AN_nfe,AN_fin,AN_afr,AN_amr,AN_asj"
all7_AF_fc="AF,AF_female,AF_male,AF_eas,AF_sas,AF_nfe,AF_fin,AF_afr,AF_amr,AF_asj"

##################################
#@1 (anyACgt0)
bash ${scrdir}/GI_master.sh "filtering" "gnomadv2_ALL7_ACqc" ${wkdir} ${scrdir} ${AC_cp} ${all7_AC_fc} "FALSE" "any" "FALSE" "any" "MAF_METADATA_gnomadv2_exomes.tsv" "${miscdir}/01_gnomadv2_all7_ACqc_varfilter_params.txt"

#@1 (allACle0)
bash ${scrdir}/GI_master.sh "filtering" "gnomadv2_ALL7_ACeq0" ${wkdir} ${scrdir} ${AC_cp} ${all7_AC_fc} "TRUE" "all" "TRUE" "all" "MAF_METADATA_gnomadv2_exomes.tsv" "${miscdir}/01_gnomadv2_all7_ACeq0_varfilter_params.txt"

##################################
#@2 (allANgt0)
bash ${scrdir}/GI_master.sh "filtering" "gnomadv2_ALL7_ACqcANqc" ${wkdir} ${scrdir} ${AN_cp} ${all7_AN_fc} "FALSE" "all" "FALSE" "all" "VarFilter_gnomadv2_ALL7_ACqc.tsv" "${miscdir}/02_gnomadv2_all7_ACqcANqc_varfilter_params.txt"

#@2 (allANle0)
bash ${scrdir}/GI_master.sh "filtering" "gnomadv2_ALL7_ACqcANeq0" ${wkdir} ${scrdir} ${AN_cp} ${all7_AN_fc} "TRUE" "any" "TRUE" "any" "VarFilter_gnomadv2_ALL7_ACqc.tsv" "${miscdir}/02_gnomadv2_all7_ACqcANeq0_varfilter_params.txt"

##################################
#@3 (CallRateQC)
bash ${scrdir}/GI_master.sh "filtering" "gnomadv2_ALL7_ACqcANqcCRqc" ${wkdir} ${scrdir} ${AN_cp} ${all7_AN_fc} "TRUE" "all" "TRUE" "all" "VarFilter_gnomadv2_ALL7_ACqcANqc.tsv" "${miscdir}/03_gnomadv2_all7_ACqcANqcCRqc_varfilter_params.txt"

##################################
#@4 (one fix ancestry vs 6 ancestries, 32 combinations in each ancestry. total 224)
#non-CRqc
bash ${scrdir}/master.sh "filtering" "gnomadv2_ALL7_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all7_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_gnomadv2_ALL7_ACqcANqc.tsv" "${miscdir}/04_gnomadv2_all7_c32_224_varfilter_params.txt"

#10%AN-CRqc
bash ${scrdir}/GI_master.sh "filtering" "gnomadv2_ALL7_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all7_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_gnomadv2_ALL7_ACqcANqcCR10qc_7.tsv" "${miscdir}/04_gnomadv2_all7_CR10_c32_224_varfilter_params.txt"

#20%AN-CRqc
bash ${scrdir}/GI_master.sh "filtering" "gnomadv2_ALL7_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all7_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_gnomadv2_ALL7_ACqcANqcCR20qc_7.tsv" "${miscdir}/04_gnomadv2_all7_CR20_c32_224_varfilter_params.txt"

#30%AN-CRqc
bash ${scrdir}/GI_master.sh "filtering" "gnomadv2_ALL7_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all7_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_gnomadv2_ALL7_ACqcANqcCR30qc_7.tsv" "${miscdir}/04_gnomadv2_all7_CR30_c32_224_varfilter_params.txt"

#40%AN-CRqc
bash ${scrdir}/GI_master.sh "filtering" "gnomadv2_ALL7_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all7_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_gnomadv2_ALL7_ACqcANqcCR40qc_7.tsv" "${miscdir}/04_gnomadv2_all7_CR40_c32_224_varfilter_params.txt"

#############################################################################################
### stats # post-analysis
## #1.module #2.submodule #3.wkdir #4.scrdir #5.filename
#AC/AN QC files
#Call rate QC files
input_dir="${wkdir}"
post_analysis_list="${miscdir}/VarFilter_gnomadv2_post-analysis_CR_list.txt"

### gnomadv2.1.1
while IFS= read -r filename; do

    file="${input_dir}${filename}"

    if [[ -f "$file" && $file == *.tsv ]]; then
        bash "${scrdir}/GI_master.sh" "GET" "gnomadv2_post_analysis" "${wkdir}" "${scrdir}" "${input_dir}" "${filename}"
    fi
done < "$post_analysis_list"

input_dir="${wkdir}/gnomadv2_CR0/"
for file in "$input_dir"/*; do
        if [[ $file == *.tsv ]]; then
                filename=$(basename "$file")
                bash ${scrdir}/GI_master.sh "GET" "gnomadv2_CR0" ${wkdir} ${scrdir} ${input_dir} ${filename}
        fi
done

input_dir="${wkdir}/gnomadv2_CR10/"
for file in "$input_dir"/*; do
        if [[ $file == *.tsv ]]; then
                filename=$(basename "$file")
                bash ${scrdir}/GI_master.sh "GET" "gnomadv2_CR10" ${wkdir} ${scrdir} ${input_dir} ${filename}
        fi
done

input_dir="${wkdir}/gnomadv2_CR20/"
for file in "$input_dir"/*; do
        if [[ $file == *.tsv ]]; then
                filename=$(basename "$file")
                bash ${scrdir}/GI_master.sh "GET" "gnomadv2_CR20" ${wkdir} ${scrdir} ${input_dir} ${filename}
        fi
done

input_dir="${wkdir}/gnomadv2_CR30/"
for file in "$input_dir"/*; do
        if [[ $file == *.tsv ]]; then
                filename=$(basename "$file")
                bash ${scrdir}/GI_master.sh "GET" "gnomadv2_CR30" ${wkdir} ${scrdir} ${input_dir} ${filename}
        fi
done

input_dir="${wkdir}/gnomadv2_CR40/"
for file in "$input_dir"/*; do
        if [[ $file == *.tsv ]]; then
                filename=$(basename "$file")
                bash ${scrdir}/GI_master.sh "GET" "gnomadv2_CR40" ${wkdir} ${scrdir} ${input_dir} ${filename}
        fi
done
#############################################################################################
