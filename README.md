# VarFilter

This is a variants filtering analysis pipeline for the WES from gnomAD v2.1.1 and v4.0.0. 
We analysis the gnomADv4.0.0 data for allele count, allele number, and allele frequency. 
This study aims to identify population-specific common or rare genetic variants by leveraging WES data and analyzing differences in allele frequencies across populations. We employed a customized filtering and analysis pipeline that includes data extraction, variant filtering.

### Variant extraction
First, we used BCFtools to decompress the compressed VCF files and calculate variant statistics for each chromosome. Next, we developed a Python script that utilizes the cyvcf2 package to extract allele frequencies and other relevant information from the VCF files and organize the results into a standard TSV format.

gnomAD v4.0.0 WES:
| Chromosome | Number of Records | Number of SNPs | Number of Indels |
|------------|-------------------|----------------|------------------|
| chr1       | 17558305          | 16086987       | 1471318          |
| chr2       | 12963790          | 11856798       | 1106992          |
| chr3       | 10208076          | 9341677        | 866399           |
| chr4       | 7252480           | 6629009        | 623471           |
| chr5       | 8156768           | 7463296        | 693472           |
| chr6       | 8573431           | 7827013        | 746418           |
| chr7       | 9233607           | 8436897        | 796709           |
| chr8       | 6779302           | 6219823        | 559479           |
| chr9       | 7476742           | 6839888        | 636854           |
| chr10      | 7210142           | 6600338        | 609804           |
| chr11      | 10526962          | 9647605        | 879357           |
| chr12      | 9855795           | 9005315        | 850480           |
| chr13      | 3549140           | 3243961        | 305179           |
| chr14      | 6243282           | 5704270        | 539012           |
| chr15      | 7010578           | 6420827        | 589751           |
| chr16      | 8785928           | 8055224        | 730704           |
| chr17      | 10744750          | 9813126        | 931624           |
| chr18      | 3246732           | 2972210        | 274522           |
| chr19      | 11706291          | 10648129       | 1058162          |
| chr20      | 4616729           | 4214591        | 402138           |
| chr21      | 2188842           | 1995826        | 193016           |
| chr22      | 4845199           | 4442419        | 402780           |
| chrX       | 4685140           | 4303822        | 381318           |
| chrY       | 140758            | 128336         | 12422            |
| Total      | 183558769         | 167897387      | 15661381         |

### Variant QC
In variant filtering process for gnomAD v4.0.0, initially, we performed quality control based on allele count (AC) and allele number (AN) values. We then employed two population genetic structure models, ModelA and ModelB, to account for different population stratification scenarios. 
ModelA considered eight populations (EAS, SAS, NFE, FIN, AFR, AMR, ASJ, and MID).
ModelB focused on seven populations (EAS, SAS, NFE, FIN, AFR, AMR, and ASJ).

gnomAD v4.0.0 WES:
| STEP | Description | Number of Records |
|------|----|-------------------|
| 0    | extract the vcf | 183558769 |
| 1    | Keep any AC > 0 in all pop | 86291641 |
| 2A (Allele count QC)   | ModelA: Keep any AC > 0 in 8 pop | 84048207 |
| 3A (Allele number QC)   | ModelA: Keep all AN > 0 in 8 pop | 83977475 |
| 4A.1 (call rate 10% QC)   | ModelA: Keep all AN > 10%ANmax in 8 pop | 83651955 |
| 4A.2 (call rate 20% QC)   | ModelA: Keep all AN > 20%ANmax in 8 pop | 83355286 |
| 4A.3 (call rate 30% QC)   | ModelA: Keep all AN > 30%ANmax in 8 pop | 82995279 |
| 4A.4 (call rate 40% QC)   | ModelA: Keep all AN > 40%ANmax in 8 pop | 82376516 |
| 2B (Allele count QC)   | ModelB: Keep any AC > 0 in 7 pop | 83515954 |
| 3B (Allele number QC)   | ModelB: Keep all AN > 0 in 7 pop | 83458401 |
| 4B.1 (call rate 10% QC)   | ModelB: Keep all AN > 10%ANmax in 7 pop | 83127419 |
| 4B.2 (call rate 20% QC)   | ModelB: Keep all AN > 20%ANmax in 7 pop | 82833852 |
| 4B.3 (call rate 30% QC)   | ModelB: Keep all AN > 30%ANmax in 7 pop | 82477764 |
| 4B.4 (call rate 40% QC)   | ModelB: Keep all AN > 40%ANmax in 7 pop | 81866138 |

In variant filtering process for gnomAD v2.1.1, we performed quality control based on allele count (AC) and allele number (AN) values. We only employed one genetic structure models about seven populations (EAS, SAS, NFE, FIN, AFR, AMR, and ASJ).
gnomAD v2.1.1 WES:
| STEP | Description | Number of Records |
|------|----|-------------------|
| 0    | extract the vcf | 17209972 |
| 1 (Allele count QC)    | Keep any AC > 0 in all pop | 15425384 |
| 2 (Allele number QC)   | Keep all AN > 0 in all pop | 15417683 |
| 3.1 (call rate 10% QC)   | Keep all AN > 10%ANmax in all pop | 15408487 |
| 3.2 (call rate 20% QC)   | Keep all AN > 20%ANmax in all pop | 15404555 |
| 3.3 (call rate 30% QC)   | Keep all AN > 30%ANmax in all pop | 15401073 |
| 3.4 (call rate 40% QC)   | Keep all AN > 40%ANmax in all pop | 15397425 |

### Variant filtering
We designed a series of filtering condition combinations based on allele frequency differences among populations to progressively narrow down the candidate variant set. The filtering conditions included:
- Variants with allele frequency greater than or equal to 1%, 5%, 10%, or 20% in the target population and less than 0.5%, 0.1%, 0.05%, or 0.01% in all other populations.
- Variants with allele frequency less than 0.5%, 0.1%, 0.05%, or 0.01% in the target population and greater than or equal to 1%, 5%, 10%, or 20% in all other populations.

These filtering conditions were applied to (STEP)3A, 4A.1, 4A.2, 4A.3, 4A.4 files in ModelA for gnomAD v4.0.0, resulting in a total of 256x5 condition combinations for ModelA.
![VarFilter_summary_gnomADv4.0_ModelA_CR40](https://github.com/853tony/VarFilter/blob/main/VarFilter_summary_ModelA_CR40.png)
#gnomAD v4.0.0 modelA: 256 condition combinations AFTER CALL RATE 40%QC.

These filtering conditions were applied to (STEP)3B, 4B.1, 4B.2, 4B.3, 4B.4 files in ModelB for gnomAD v4.0.0, resulting in a total of 224x5 condition combinations for ModelB.
![VarFilter_summary_gnomADv4.0_ModelB_CR40](https://github.com/853tony/VarFilter/blob/main/VarFilter_summary_ModelB_CR40.png)
#gnomAD v4.0.0 modelB: 224 condition combinations AFTER CALL RATE 40%QC.

These filtering conditions were applied to (STEP)3.1, 3.2, 3.3, 3.4 files for gnomAD v2.1.1, resulting in a total of 224x5 condition combinations for seven populations (EAS, SAS, NFE, FIN, AFR, AMR, and ASJ).
![VarFilter_summary_gnomADv2.1_CR40](https://github.com/853tony/VarFilter/blob/main/VarFilter_summary_CR40.png)
#gnomAD v2.1.1 seven populations (EAS, SAS, NFE, FIN, AFR, AMR, and ASJ): 224 condition combinations AFTER CALL RATE 40%QC.
