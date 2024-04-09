#!/usr/bin/sh

#SBATCH -A MST109178

#SBATCH -J combine2excel

#SBATCH -p ngs372G

#SBATCH -c 56

#SBATCH --mem=372g

#SBATCH -o ./LOG/combine2excel.out.log

#SBATCH -e ./LOG/combine2excel.err.log

#SBATCH --mail-user=d12456001@g.ntu.edu.tw    # email

#SBATCH --mail-type=ALL

module add biology/Python/3.11.0

wkdir=/staging/biology/edwardch826/projects/genetic_incompatibility_MAF/
mkdir -p ${wkdir}/excel_data/
outputdir=${wkdir}/excel_data/
###python 04_combine2excel.py input_folder output_file_name

python 04_combine2excel.py ${wkdir}/condition_B ${outputdir}/AF_gnomadv4_exomes_condition_B "b"
python 04_combine2excel.py ${wkdir}/condition_B_nz ${outputdir}/AF_gnomadv4_exomes_condition_B_nz "b"

python 04_combine2excel.py ${wkdir}/condition_C ${outputdir}/AF_gnomadv4_exomes_condition_C "C_C1_1,C_C2_1,C_C3_1,C_C4_1,C2,C3,C4,C5,C6,C7,C8"
python 04_combine2excel.py ${wkdir}/condition_C_nz ${outputdir}/AF_gnomadv4_exomes_condition_C_nz "C_C1_1,C_C2_1,C_C3_1,C_C4_1,C2,C3,C4,C5,C6,C7,C8"

python 04_combine2excel.py ${wkdir}/condition_D ${outputdir}/AF_gnomadv4_exomes_condition_D "D1,D2,D3,D4,D5,D6,D7,D8"
python 04_combine2excel.py ${wkdir}/condition_D_nz ${outputdir}/AF_gnomadv4_exomes_condition_D_nz "D1,D2,D3,D4,D5,D6,D7,D8"

