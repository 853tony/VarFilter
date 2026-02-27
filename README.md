# VarFilter

This is a variant filtering analysis pipeline for the WES from gnomADv4.0.0. We analyzed the gnomADv4.0.0 data for allele count, allele number, and allele frequency. 

This study aims to identify population-specific common or rare genetic variants by leveraging WES data and analyzing differences in allele frequencies across populations. We employed a customized filtering and analysis pipeline that includes data extraction and variant filtering.

### Variants extraction
First, we used BCFtools to decompress the compressed VCF files and calculate variant statistics for each chromosome. Next, we developed a Python script that utilizes the cyvcf2 package to extract allele frequencies and other relevant information from the VCF files and organize the results into a standard TSV format.

gnomADv4.0.0 WES:
| Chromosome | Number of Variants | Number of SNPs | Number of Indels |
|------------|-------------------|----------------|------------------|
| chr1       | 17,558,305          | 16,086,987       | 1,471,318          |
| chr2       | 12,963,790          | 11,856,798       | 1,106,992          |
| chr3       | 10,208,076          | 9,341,677        | 866,399           |
| chr4       | 7,252,480           | 6,629,009        | 623,471           |
| chr5       | 8,156,768           | 7,463,296        | 693,472           |
| chr6       | 8,573,431           | 7,827,013        | 746,418           |
| chr7       | 9,233,607           | 8,436,897        | 796,709           |
| chr8       | 6,779,302           | 6,219,823        | 559,479           |
| chr9       | 7,476,742           | 6,839,888        | 636,854           |
| chr10      | 7,210,142           | 6,600,338        | 609,804           |
| chr11      | 10,526,962          | 9,647,605        | 879,357           |
| chr12      | 9,855,795           | 9,005,315        | 850,480           |
| chr13      | 3,549,140           | 3,243,961        | 305,179           |
| chr14      | 6,243,282           | 5,704,270        | 539,012           |
| chr15      | 7,010,578           | 6,420,827        | 589,751           |
| chr16      | 8,785,928           | 8,055,224        | 730,704           |
| chr17      | 10,744,750          | 9,813,126        | 931,624           |
| chr18      | 3,246,732           | 2,972,210        | 274,522           |
| chr19      | 11,706,291          | 10,648,129       | 1,058,162          |
| chr20      | 4,616,729           | 4,214,591        | 402,138           |
| chr21      | 2,188,842           | 1,995,826        | 193,016           |
| chr22      | 4,845,199           | 4,442,419        | 402,780           |
| chrX       | 4,685,140           | 4,303,822        | 381,318           |
| chrY       | 140,758            | 128,336         | 12,422            |
| Total      | 183,558,769         | 167,897,387      | 15,661,381         |

### Variants QC
In the variant filtering process for gnomADv4.0.0, we initially performed quality control based on allele count (AC) and allele number (AN) values. We then employed two population genetic structure models, Model A and Model B, to account for different population stratification scenarios. 

Model A considered 8 populations (EAS, SAS, NFE, FIN, AFR, AMR, ASJ, and MID).

Model B focused on 7 populations (EAS, SAS, NFE, FIN, AFR, AMR, and ASJ).

gnomAD v4.0.0 WES:
| STEP | Description | Number of Variants |
|------|----|-------------------|
| 0    | Extract the vcf | 183,558,769 |
| 1    | Keep any AC > 0 in all pop | 86,291,641 |
| 2A (allele count QC)   | Model A: Keep any AC > 0 in 8 pop | 84,048,207 |
| 3A (allele number QC)   | Model A: Keep all AN > 0 in 8 pop | 83,977,475 |
| 4A.1 (call rate 10% QC)   | Model A: Keep all AN > 10%ANmax in 8 pop | 83,651,955 |
| 4A.2 (call rate 20% QC)   | Model A: Keep all AN > 20%ANmax in 8 pop | 83,355,286 |
| 4A.3 (call rate 30% QC)   | Model A: Keep all AN > 30%ANmax in 8 pop | 82,995,279 |
| 4A.4 (call rate 40% QC)   | Model A: Keep all AN > 40%ANmax in 8 pop | 82,376,516 |
| 2B (allele count QC)   | Model B: Keep any AC > 0 in 7 pop | 83,515,954 |
| 3B (allele number QC)   | Model B: Keep all AN > 0 in 7 pop | 83,458,401 |
| 4B.1 (call rate 10% QC)   | Model B: Keep all AN > 10%ANmax in 7 pop | 83,127,419 |
| 4B.2 (call rate 20% QC)   | Model B: Keep all AN > 20%ANmax in 7 pop | 82,833,852 |
| 4B.3 (call rate 30% QC)   | Model B: Keep all AN > 30%ANmax in 7 pop | 82,477,764 |
| 4B.4 (call rate 40% QC)   | Model B: Keep all AN > 40%ANmax in 7 pop | 81,866,138 |

### Variants filtering
We designed a series of filtering condition combinations based on allele frequency differences among populations to progressively narrow down the candidate variant set. The filtering conditions included:
- Variants with allele frequency greater than or equal to 1%, 5%, 10%, or 20% in the target population and less than 0.5%, 0.1%, 0.05%, or 0.01% in all other populations<sup>*</sup>.
- Variants with allele frequency less than 0.5%, 0.1%, 0.05%, or 0.01% in the target population and greater than or equal to 1%, 5%, 10%, or 20% in all other populations<sup>*</sup>.

<sup>*</sup>Other populations defined according to the model: 7 populations for Model A; 6 populations for Model B.

These filtering conditions were applied to (STEP)3A, 4A.1, 4A.2, 4A.3, 4A.4 files in Model A for gnomADv4.0.0, resulting in a total of 256x5 condition combinations for Model A.
![VarFilter_summary_gnomADv4.0_ModelA_CR40](https://github.com/853tony/VarFilter/blob/main/VarFilter_summary_ModelA_CR40.png)
#gnomADv4.0.0 model A: 256 condition combinations after call rate 40% QC.

These filtering conditions were applied to (STEP)3B, 4B.1, 4B.2, 4B.3, 4B.4 files in Model B for gnomADv4.0.0, resulting in a total of 224x5 condition combinations for Model B.
![VarFilter_summary_gnomADv4.0_ModelB_CR40](https://github.com/853tony/VarFilter/blob/main/VarFilter_summary_ModelB_CR40.png)
#gnomADv4.0.0 model B: 224 condition combinations after call rate 40% QC.
