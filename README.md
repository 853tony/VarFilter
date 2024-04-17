# VarFilter

This is a variants filtering analysis pipeline for the WES from gnomAD v4.0.0. 
We analysis the gnomADv4.0.0 data for allele count, allele number, and allele frequency. 
This study aims to identify population-specific common or rare genetic variants by leveraging WES data and analyzing differences in allele frequencies across populations. We employed a customized filtering and analysis pipeline that includes data extraction, variant filtering.

### Variant extraction
First, we used BCFtools to decompress the compressed VCF files and calculate variant statistics for each chromosome. Next, we developed a Python script that utilizes the cyvcf2 package to extract allele frequencies and other relevant information from the VCF files and organize the results into a standard TSV format.

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
In variant filtering process, initially, we performed quality control based on allele count (AC) and allele number (AN) values. We then employed two population genetic structure models, ModelA and ModelB, to account for different population stratification scenarios. 
ModelA considered eight populations (EAS, SAS, NFE, FIN, AFR, AMR, ASJ, and MID).
ModelB focused on seven populations (EAS, SAS, NFE, FIN, AFR, AMR, and ASJ).

| STEP | Description | Number of Records |
|------|----|-------------------|
| 0    | extract the vcf | 183558769 |
| 1    | Keep any AC > 0 in all pop | 86291641 |
| 2A   | ModelA: Keep any AC > 0 in 8 pop | 84048207 |
| 3A   | ModelA: Keep all AN > 0 in 8 pop | 83977475 |
| 2B   | ModelB: Keep any AC > 0 in 7 pop | 83515954 |
| 3B   | ModelB: Keep all AN > 0 in 7 pop | 83458401 |

### Variant filtering
We designed a series of filtering condition combinations based on allele frequency differences among populations to progressively narrow down the candidate variant set. The filtering conditions included:
- Variants with allele frequency greater than or equal to 1%, 5%, 10%, or 20% in the target population and less than 0.5%, 0.1%, 0.05%, or 0.01% in all other populations.
- Variants with allele frequency less than 0.5%, 0.1%, 0.05%, or 0.01% in the target population and greater than or equal to 1%, 5%, 10%, or 20% in all other populations.
These conditions were applied to each population in both ModelA and ModelB, resulting in a total of 256 condition combinations for ModelA and 224 condition combinations for ModelB. 
