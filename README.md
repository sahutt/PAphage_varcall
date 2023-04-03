Initiate interactive job on Quest

FastQC and MultiQC

From folder containing the reads:
```
module load fastqc
module load multiqc

fastqc -o /projects/b1180/stefanie/PA_phages/fastqc/ DMS3_5_2_S113_R1_001.fastq.gz DMS3_5_2_S113_R2_001.fastq.gz /
DMS3_5_3_S114_R1_001.fastq.gz DMS3_5_3_S114_R2_001.fastq.gz DMS3_WTshort_S112_R1_001.fastq.gz DMS3_WTshort_S112_R2_001.fastq.gz /
JG024_9_1short_S115_R1_001.fastq.gz JG024_9_1short_S115_R2_001.fastq.gz JG024_9_2_S116_R1_001.fastq.gz JG024_9_2_S116_R2_001.fastq.gz

cd ../../stefanie/PA_phages/fastqc/

multiqc *
```

