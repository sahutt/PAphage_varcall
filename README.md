Initiate interactive job on Quest

FastQC and MultiQC

From folder containing the reads:
```
module load fastqc
module load multiqc

fastqc -o /projects/b1180/stefanie/PA_phages/fastqc/ DMS3_5_2_S113_R1_001.fastq.gz DMS3_5_2_S113_R2_001.fastq.gz /
DMS3_5_3_S114_R1_001.fastq.gz DMS3_5_3_S114_R2_001.fastq.gz DMS3_WTshort_S112_R1_001.fastq.gz /
DMS3_WTshort_S112_R2_001.fastq.gz JG024_9_1short_S115_R1_001.fastq.gz JG024_9_1short_S115_R2_001.fastq.gz /
JG024_9_2_S116_R1_001.fastq.gz JG024_9_2_S116_R2_001.fastq.gz

cd ../../stefanie/PA_phages/fastqc/

multiqc *
```
Check quality, confirm seqcenter already performed adapter trimming and quality control, no further QC necessary

Proceed to mapping  using bwa-mem
note: do not use -p flag in bwa-mem unless paired ends are interleaved

```
module load bwa
module load samtools 

cd /projects/b1180/stefanie/PA_phages/bwa/ 

bwa mem /projects/b1180/stefanie/PA_phages/DMS3_ref/DMS3.fasta / /projects/b1180/reads/PA_phages/DMS3_5_2_S113_R1_001.fastq.gz /
/projects/b1180/reads/PA_phages/DMS3_5_2_S113_R2_001.fastq.gz > /
/projects/b1180/stefanie/PA_phages/bwa/DMS3_5_2_aln.sam

bwa mem /projects/b1180/stefanie/PA_phages/DMS3_ref/DMS3.fasta / /projects/b1180/reads/PA_phages/DMS3_5_3_S114_R1_001.fastq.gz / /projects/b1180/reads/PA_phages/DMS3_5_3_S114_R2_001.fastq.gz > / /projects/b1180/stefanie/PA_phages/bwa/DMS3_5_3_aln.sam

bwa mem /projects/b1180/stefanie/PA_phages/DMS3_ref/DMS3.fasta / /projects/b1180/reads/PA_phages/DMS3_WTshort_S112_R1_001.fastq.gz / /projects/b1180/reads/PA_phages/DMS3_WTshort_S112_R2_001.fastq.gz > / /projects/b1180/stefanie/PA_phages/bwa/DMS3_WTshort_aln.sam

bwa mem /projects/b1180/stefanie/PA_phages/JG024_ref/JG024.fasta /
/projects/b1180/reads/PA_phages/JG024_9_1short_S115_R1_001.fastq.gz /
/projects/b1180/reads/PA_phages/JG024_9_1short_S115_R2_001.fastq.gz > /
/projects/b1180/stefanie/PA_phages/bwa/JG024_9_1short_aln.sam

bwa mem /projects/b1180/stefanie/PA_phages/JG024_ref/JG024.fasta / /projects/b1180/reads/PA_phages/JG024_9_2_S116_R1_001.fastq.gz /
/projects/b1180/reads/PA_phages/JG024_9_2_S116_R2_001.fastq.gz > /
/projects/b1180/stefanie/PA_phages/bwa/JG024_9_2_aln.sam
~~~

Process alignments using samtools

~~~
samtools view -S -b DMS3_5_2_aln.sam > /projects/b1180/stefanie/PA_phages/bwa/DMS3_5_2_aln.bam
samtools view -S -b DMS3_5_3_aln.sam > /projects/b1180/stefanie/PA_phages/bwa/DMS3_5_3_aln.bam
samtools view -S -b DMS3_WTshort_aln.sam > /projects/b1180/stefanie/PA_phages/bwa/DMS3_WTshort_aln.bam
samtools view -S -b JG024_9_1short_aln.sam > /projects/b1180/stefanie/PA_phages/bwa/JG024_9_1short_aln.bam
samtools view -S -b JG024_9_2_aln.sam > /projects/b1180/stefanie/PA_phages/bwa/JG024_9_2_aln.bam

~~~~

