## Note: step-by-step sumbit the job.

scrdir=/staging/biology/edwardch826/projects/genetic_incompatibility_MAF/VarFilter/scrs/
datadir=/staging/biology/edwardch826/biobank_genomics_data/gnomADv4.0_data/
wkdir=/staging/biology/edwardch826/projects/genetic_incompatibility_MAF/
miscdir=/staging/biology/edwardch826/projects/genetic_incompatibility_MAF/VarFilter/misc/

### extraction
### #1.module #2.submodule #3.datadir #4.wkdir #5.scrdir
bash ${scrdir}/GI_master.sh af extraction ${datadir} ${wkdir} ${scrdir}

#############################################################################################
### stats # pre-analysis
## #1.module #2.submodule #3.datadir #4.wkdir #5.scrdir
bash ${scrdir}/GI_master.sh af stats ${datadir} ${wkdir} ${scrdir}

#############################################################################################
### filtering
## #1.module #2.submodule #3.wkdir #4.scrdir #5.target_column_prefix #6.float_columns_list
## #7.equal_for_cond1 #8.all/any_for_cond1 #9.equal_for_cond2 #10.all/any_for_cond2
## #11.input_file_prefix #12.input_params_file_name
## general params
AC_cp=AC_joint_
AN_cp=AN_joint_
AF_cp=AF_joint_
all10_AC_fc="AC_joint,AC_joint_XX,AC_joint_XY,AC_joint_eas,AC_joint_sas,AC_joint_nfe,AC_joint_fin,AC_joint_afr,AC_joint_amr,AC_joint_asj,AC_joint_mid,AC_joint_ami,AC_joint_remaining"
all10_AN_fc="AN_joint,AN_joint_XX,AN_joint_XY,AN_joint_eas,AN_joint_sas,AN_joint_nfe,AN_joint_fin,AN_joint_afr,AN_joint_amr,AN_joint_asj,AN_joint_mid,AN_joint_ami,AN_joint_remaining"
all8_AC_fc="AC_joint,AC_joint_XX,AC_joint_XY,AC_joint_eas,AC_joint_sas,AC_joint_mid,AC_joint_nfe,AC_joint_fin,AC_joint_afr,AC_joint_amr,AC_joint_asj"
all8_AN_fc="AN_joint,AN_joint_XX,AN_joint_XY,AN_joint_eas,AN_joint_sas,AN_joint_mid,AN_joint_nfe,AN_joint_fin,AN_joint_afr,AN_joint_amr,AN_joint_asj"
all8_AF_fc="AF_joint,AF_joint_XX,AF_joint_XY,AF_joint_eas,AF_joint_sas,AF_joint_mid,AF_joint_nfe,AF_joint_fin,AF_joint_afr,AF_joint_amr,AF_joint_asj"
all7_AC_fc="AC_joint,AC_joint_XX,AC_joint_XY,AC_joint_eas,AC_joint_sas,AC_joint_nfe,AC_joint_fin,AC_joint_afr,AC_joint_amr,AC_joint_asj"
all7_AN_fc="AN_joint,AN_joint_XX,AN_joint_XY,AN_joint_eas,AN_joint_sas,AN_joint_nfe,AN_joint_fin,AN_joint_afr,AN_joint_amr,AN_joint_asj"
all7_AF_fc="AF_joint,AF_joint_XX,AF_joint_XY,AF_joint_eas,AF_joint_sas,AF_joint_nfe,AF_joint_fin,AF_joint_afr,AF_joint_amr,AF_joint_asj"

##################################
#@1 (anyACgt0)
bash ${scrdir}/GI_master.sh "filtering" "ALL10_ACqc" ${wkdir} ${scrdir} ${AC_cp} ${all10_AC_fc} "FALSE" "any" "FALSE" "any" "MAF_METADATA_gnomadv4_exomes.tsv" "${miscdir}/01_all10_ACqc_varfilter_params.txt"

#@1 (allACle0)
bash ${scrdir}/GI_master.sh "filtering" "ALL10_ACeq0" ${wkdir} ${scrdir} ${AC_cp} ${all10_AC_fc} "TRUE" "all" "TRUE" "all" "MAF_METADATA_gnomadv4_exomes.tsv" "${miscdir}/01_all10_ACeq0_varfilter_params.txt"

##################################
## #1.module #2.submodule #3.datadir #4.wkdir #5.scrdir #6.input #7.output #8.columns-keep
# ModelA: Split the eas,sas,nfe,fin,afr,amr,asj,mid
bash ${scrdir}/GI_master.sh af "extraction_rm_col" ${datadir} ${wkdir} ${scrdir} VarFilter_ALL10_ACqc.tsv VarFilter_ModelA_gnomadv4_exomes.tsv "1-34,38-43"
# ModelB: Split the eas,sas,nfe,fin,afr,amr,asj
bash ${scrdir}/GI_master.sh af "extraction_rm_col" ${datadir} ${wkdir} ${scrdir} VarFilter_ALL10_ACqc.tsv VarFilter_ModelB_gnomadv4_exomes.tsv "1-22,26-34,38-43"

##################################
#@2a (anyACgt0)
bash ${scrdir}/GI_master.sh "filtering" "ModelA_ALL8_ACqc" ${wkdir} ${scrdir} ${AC_cp} ${all8_AC_fc} "FALSE" "any" "FALSE" "any" "VarFilter_ModelA_gnomadv4_exomes.tsv" "${miscdir}/02a_all8_ACqc_varfilter_params.txt"

#@2a (allACle0)
bash ${scrdir}/GI_master.sh "filtering" "ModelA_ALL8_ACeq0" ${wkdir} ${scrdir} ${AC_cp} ${all8_AC_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelA_gnomadv4_exomes.tsv" "${miscdir}/02a_all8_ACeq0_varfilter_params.txt"

##################################
#@2b (anyACgt0)
bash ${scrdir}/GI_master.sh "filtering" "ModelB_ALL7_ACqc" ${wkdir} ${scrdir} ${AC_cp} ${all7_AC_fc} "FALSE" "any" "FALSE" "any" "VarFilter_ModelB_gnomadv4_exomes.tsv" "${miscdir}/02b_all7_ACqc_varfilter_params.txt"

#@2b (allACle0)
bash ${scrdir}/GI_master.sh "filtering" "ModelB_ALL7_ACeq0" ${wkdir} ${scrdir} ${AC_cp} ${all7_AC_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelB_gnomadv4_exomes.tsv" "${miscdir}/02b_all7_ACeq0_varfilter_params.txt"

##################################
#@3a (allANgt0)
bash ${scrdir}/GI_master.sh "filtering" "ModelA_ALL8_ACqcANqc" ${wkdir} ${scrdir} ${AN_cp} ${all8_AN_fc} "FALSE" "all" "FALSE" "all" "VarFilter_ModelA_ALL8_ACqc.tsv" "${miscdir}/03a_all8_ACqcANqc_varfilter_params.txt"

#@3a (allANle0)
bash ${scrdir}/GI_master.sh "filtering" "ModelA_ALL8_ACqcANeq0" ${wkdir} ${scrdir} ${AN_cp} ${all8_AN_fc} "TRUE" "any" "TRUE" "any" "VarFilter_ModelA_ALL8_ACqc.tsv" "${miscdir}/03a_all8_ACqcANeq0_varfilter_params.txt"

##################################
#@3b (allANgt0)
bash ${scrdir}/GI_master.sh "filtering" "ModelB_ALL7_ACqcANqc" ${wkdir} ${scrdir} ${AN_cp} ${all7_AN_fc} "FALSE" "all" "FALSE" "all" "VarFilter_ModelB_ALL7_ACqc.tsv" "${miscdir}/03b_all7_ACqcANqc_varfilter_params.txt"

#@3b (allANle0)
bash ${scrdir}/GI_master.sh "filtering" "ModelB_ALL7_ACqcANeq0" ${wkdir} ${scrdir} ${AN_cp} ${all7_AN_fc} "TRUE" "any" "TRUE" "any" "VarFilter_ModelB_ALL7_ACqc.tsv" "${miscdir}/03b_all7_ACqcANeq0_varfilter_params.txt"

##################################
#@4a (CallRateQC)
bash ${scrdir}/GI_master.sh "filtering" "ModelA_ALL8_ACqcANqcCRqc" ${wkdir} ${scrdir} ${AN_cp} ${all8_AN_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelA_ALL8_ACqcANqc.tsv" "${miscdir}/04a_all8_ACqcANqcCRqc_varfilter_params.txt"

#@4b (CallRateQC)
bash ${scrdir}/GI_master.sh "filtering" "ModelB_ALL7_ACqcANqcCRqc" ${wkdir} ${scrdir} ${AN_cp} ${all7_AN_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelB_ALL7_ACqcANqc.tsv" "${miscdir}/04b_all7_ACqcANqcCRqc_varfilter_params.txt"

##################################
#@5a (one fix ancestry vs 7 ancestries, 32 combinations in each ancestry. total 256)
bash ${scrdir}/GI_master.sh "filtering" "ModelA_ALL8_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all8_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelA_ALL8_ACqcANqc.tsv" "${miscdir}/05a_all8_c32_256_varfilter_params.txt"

#10%AN
bash ${scrdir}/GI_master.sh "filtering" "ModelA_ALL8_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all8_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelA_ALL8_ACqcANqcCR10qc_8.tsv" "${miscdir}/05a_all8_CR10_c32_256_varfilter_params.txt"

#20%AN
bash ${scrdir}/GI_master.sh "filtering" "ModelA_ALL8_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all8_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelA_ALL8_ACqcANqcCR20qc_8.tsv" "${miscdir}/05a_all8_CR20_c32_256_varfilter_params.txt"

#30%AN
bash ${scrdir}/GI_master.sh "filtering" "ModelA_ALL8_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all8_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelA_ALL8_ACqcANqcCR30qc_8.tsv" "${miscdir}/05a_all8_CR30_c32_256_varfilter_params.txt"

#40%AN
bash ${scrdir}/GI_master.sh "filtering" "ModelA_ALL8_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all8_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelA_ALL8_ACqcANqcCR40qc_8.tsv" "${miscdir}/05a_all8_CR40_c32_256_varfilter_params.txt"

##################################
#@5b (one fix ancestry vs 6 ancestries, 32 combinations in each ancestry. total 224)
bash ${scrdir}/GI_master.sh "filtering" "ModelB_ALL7_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all7_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelB_ALL7_ACqcANqc.tsv" "${miscdir}/05b_all7_c32_224_varfilter_params.txt"

#10%AN
bash ${scrdir}/GI_master.sh "filtering" "ModelB_ALL7_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all7_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelB_ALL7_ACqcANqcCR10qc_7.tsv" "${miscdir}/05b_all7_CR10_c32_224_varfilter_params.txt"

#20%AN
bash ${scrdir}/GI_master.sh "filtering" "ModelB_ALL7_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all7_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelB_ALL7_ACqcANqcCR20qc_7.tsv" "${miscdir}/05b_all7_CR20_c32_224_varfilter_params.txt"

#30%AN
bash ${scrdir}/GI_master.sh "filtering" "ModelB_ALL7_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all7_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelB_ALL7_ACqcANqcCR30qc_7.tsv" "${miscdir}/05b_all7_CR30_c32_224_varfilter_params.txt"

#40%AN
bash ${scrdir}/GI_master.sh "filtering" "ModelB_ALL7_SpeAncVarFil" ${wkdir} ${scrdir} ${AF_cp} ${all7_AF_fc} "TRUE" "all" "TRUE" "all" "VarFilter_ModelB_ALL7_ACqcANqcCR40qc_7.tsv" "${miscdir}/05b_all7_CR40_c32_224_varfilter_params.txt"

#############################################################################################
### stats # post-analysis
## #1.module #2.submodule #3.wkdir #4.scrdir #5.filename
#@4basic stats
#AC/AN QC files
input_dir="${wkdir}"
post_analysis_list="${miscdir}/VarFilter_post-analysis_list.txt"

while IFS= read -r filename; do

    file="${input_dir}${filename}"

    if [[ -f "$file" && $file == *.tsv ]]; then
        bash "${scrdir}/GI_master.sh" "GET" "post_analysis" "${wkdir}" "${scrdir}" "${input_dir}" "${filename}"
    fi
done < "$post_analysis_list"

#Call rate QC files
post_analysis_list="${miscdir}/VarFilter_CR_list.txt"

while IFS= read -r filename; do

    file="${input_dir}${filename}"

    if [[ -f "$file" && $file == *.tsv ]]; then
        bash "${scrdir}/GI_master.sh" "GET" "CRQC_post_analysis" "${wkdir}" "${scrdir}" "${input_dir}" "${filename}"
    fi
done < "$post_analysis_list"

#@4a stats
input_dir="${wkdir}/ModelA_v1/"
for file in "$input_dir"/*; do
	if [[ $file == *.tsv ]]; then
		filename=$(basename "$file")
		bash ${scrdir}/GI_master.sh "GET" "ModelA" ${wkdir} ${scrdir} ${input_dir} ${filename}
 	fi
done

input_dir="${wkdir}/ModelA_CR10/"
for file in "$input_dir"/*; do
        if [[ $file == *.tsv ]]; then
                filename=$(basename "$file")
                bash ${scrdir}/GI_master.sh "GET" "ModelA_CR" ${wkdir} ${scrdir} ${input_dir} ${filename}
        fi
done

input_dir="${wkdir}/ModelA_CR20/"
for file in "$input_dir"/*; do
        if [[ $file == *.tsv ]]; then
                filename=$(basename "$file")
                bash ${scrdir}/GI_master.sh "GET" "ModelA_CR" ${wkdir} ${scrdir} ${input_dir} ${filename}
        fi
done

input_dir="${wkdir}/ModelA_CR30/"
for file in "$input_dir"/*; do
        if [[ $file == *.tsv ]]; then
                filename=$(basename "$file")
                bash ${scrdir}/GI_master.sh "GET" "ModelA_CR" ${wkdir} ${scrdir} ${input_dir} ${filename}
        fi
done

input_dir="${wkdir}/ModelA_CR40/"
for file in "$input_dir"/*; do
        if [[ $file == *.tsv ]]; then
                filename=$(basename "$file")
                bash ${scrdir}/GI_master.sh "GET" "ModelA_CR" ${wkdir} ${scrdir} ${input_dir} ${filename}
        fi
done

#@4b stats
input_dir="${wkdir}/ModelB_v1/"
for file in "$input_dir"/*; do
       if [[ $file == *.tsv ]]; then
               filename=$(basename "$file")
               bash ${scrdir}/GI_master.sh "GET" "ModelB" ${wkdir} ${scrdir} ${input_dir} ${filename}
       fi
done

input_dir="${wkdir}/ModelB_CR10/"
for file in "$input_dir"/*; do
       if [[ $file == *.tsv ]]; then
               filename=$(basename "$file")
               bash ${scrdir}/GI_master.sh "GET" "ModelB_CR" ${wkdir} ${scrdir} ${input_dir} ${filename}
       fi
done

input_dir="${wkdir}/ModelB_CR20/"
for file in "$input_dir"/*; do
       if [[ $file == *.tsv ]]; then
               filename=$(basename "$file")
               bash ${scrdir}/GI_master.sh "GET" "ModelB_CR" ${wkdir} ${scrdir} ${input_dir} ${filename}
       fi
done

input_dir="${wkdir}/ModelB_CR30/"
for file in "$input_dir"/*; do
       if [[ $file == *.tsv ]]; then
               filename=$(basename "$file")
               bash ${scrdir}/GI_master.sh "GET" "ModelB_CR" ${wkdir} ${scrdir} ${input_dir} ${filename}
       fi
done

input_dir="${wkdir}/ModelB_CR40/"
for file in "$input_dir"/*; do
       if [[ $file == *.tsv ]]; then
               filename=$(basename "$file")
               bash ${scrdir}/GI_master.sh "GET" "ModelB_CR" ${wkdir} ${scrdir} ${input_dir} ${filename}
       fi
done

#############################################################################################
