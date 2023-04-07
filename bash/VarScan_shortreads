# Initiate interactive job on Quest

srun --account=p31750 --partition=normal -N 1 -n 1 --mem=10G --time=04:00:00 --pty bash

# FastQC and MultiQC  

Check quality, confirm seqcenter already performed adapter trimming and quality control
no further QC necessary

Location containing reads: /projects/b1180/reads/PA_phages
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

# Mapping  using bwa-mem  
Note: do not use -p flag in bwa-mem unless paired ends are interleaved

```
module load bwa

cd /projects/b1180/stefanie/PA_phages/bwa/ 

bwa mem /projects/b1180/stefanie/PA_phages/DMS3_ref/DMS3.fasta / /projects/b1180/reads/PA_phages/DMS3_5_2_S113_R1_001.fastq.gz /
/projects/b1180/reads/PA_phages/DMS3_5_2_S113_R2_001.fastq.gz > /
/projects/b1180/stefanie/PA_phages/bwa/DMS3_5_2_aln.sam

bwa mem /projects/b1180/stefanie/PA_phages/DMS3_ref/DMS3.fasta / /projects/b1180/reads/PA_phages/DMS3_5_3_S114_R1_001.fastq.gz / /projects/b1180/reads/PA_phages/DMS3_5_3_S114_R2_001.fastq.gz > /
/projects/b1180/stefanie/PA_phages/bwa/DMS3_5_3_aln.sam

bwa mem /projects/b1180/stefanie/PA_phages/DMS3_ref/DMS3.fasta / /projects/b1180/reads/PA_phages/DMS3_WTshort_S112_R1_001.fastq.gz / /projects/b1180/reads/PA_phages/DMS3_WTshort_S112_R2_001.fastq.gz > / /projects/b1180/stefanie/PA_phages/bwa/DMS3_WTshort_aln.sam

bwa mem /projects/b1180/stefanie/PA_phages/JG024_ref/JG024.fasta /
/projects/b1180/reads/PA_phages/JG024_9_1short_S115_R1_001.fastq.gz /
/projects/b1180/reads/PA_phages/JG024_9_1short_S115_R2_001.fastq.gz > /
/projects/b1180/stefanie/PA_phages/bwa/JG024_9_1short_aln.sam

bwa mem /projects/b1180/stefanie/PA_phages/JG024_ref/JG024.fasta / /projects/b1180/reads/PA_phages/JG024_9_2_S116_R1_001.fastq.gz /
/projects/b1180/reads/PA_phages/JG024_9_2_S116_R2_001.fastq.gz > /
/projects/b1180/stefanie/PA_phages/bwa/JG024_9_2_aln.sam
```

# Process alignments using samtools
Location: /projects/b1180/stefanie/PA_phages/bwa

1. Convert .sam to .bam using samtools view

-b indicates bam file out
-o output filename

```
module load samtools 

samtools view -b -o DMS3_5_2.aligned.bam DMS3_5_2_aln.sam
samtools view -b -o DMS3_5_3.aligned.bam DMS3_5_3_aln.sam
samtools view -b -o DMS3_WTshort.aligned.bam DMS3_WTshort_aln.sam
samtools view -b -o JG024_9_1short.aligned.bam JG024_9_1short_aln.sam
samtools view -b -o JG024_9_2.aligned.bam JG024_9_2_aln.sam

```

2. Sort entries in .bam by location using samtools sort

```
samtools sort -o DMS3_5_2.sorted.bam DMS3_5_2.aligned.bam
samtools sort -o DMS3_5_3.sorted.bam DMS3_5_3.aligned.bam
samtools sort -o DMS3_WTshort.sorted.bam DMS3_WTshort.aligned.bam
samtools sort -o JG024_9_1short.sorted.bam JG024_9_1short.aligned.bam
samtools sort -o JG024_9_2.sorted.bam JG024_9_2.aligned.bam
```

3. Generate a pileup file from which we can detect variants using samtools mpileup
-B disables Base Alignment Quality (BAQ) per VarScan recommendation
-f fasta reference file
-o output file

```
samtools mpileup -B -f /projects/b1180/stefanie/PA_phages/DMS3_ref/DMS3.fasta -o DMS3_5_2.pileup  DMS3_5_2.sorted.bam
samtools mpileup -B -f /projects/b1180/stefanie/PA_phages/DMS3_ref/DMS3.fasta -o DMS3_5_3.pileup DMS3_5_3.sorted.bam
samtools mpileup -B -f /projects/b1180/stefanie/PA_phages/DMS3_ref/DMS3.fasta -o DMS3_WTshort.pileup / DMS3_WTshort.sorted.bam
samtools mpileup -B -f /projects/b1180/stefanie/PA_phages/JG024_ref/JG024.fasta -o JG024_9_1short.pileup / JG024_9_1short.sorted.bam
samtools mpileup -B -f /projects/b1180/stefanie/PA_phages/JG024_ref/JG024.fasta -o JG024_9_2.pileup JG024_9_2.sorted.bam
```

# Search for high frequency variants using VarScan
Location: /projects/b1180/software 

mpileup2cns command searches for all SNPs and indels in pileup file  
--output-vcf - this is a boolean and must be set to 1 as shown below, this is NOT for an outfile name  
--min-coverage - read depth at position, default is 8  
--min-reads2 - mminimum supporting reads to call a variant, default is 2  
--min-var-freq - minimum variant allele frequency, default is 0.01  
--min-freq-for-hom - minimum frequency to call a homozygote, default is 0.75  
--variants - reports only SNPs and Indels in output (vcf was unreadable without this flag)  

```
module load java

java -jar VarScan.v2.4.6.jar mpileup2cns /projects/b1180/stefanie/PA_phages/bwa/DMS3_5_2.pileup /
--output-vcf 1 --min-coverage 30 --min-reads2 20 --min-var-freq 0.8 --variants > / /projects/b1180/stefanie/PA_phages/varscan/DMS3_5_2_variants.vcf

java -jar VarScan.v2.4.6.jar mpileup2cns /projects/b1180/stefanie/PA_phages/bwa/DMS3_5_3.pileup /
--output-vcf 1 --min-coverage 30 --min-reads2 20 --min-var-freq 0.8 --variants > / /projects/b1180/stefanie/PA_phages/varscan/DMS3_5_3_variants.vcf

java -jar VarScan.v2.4.6.jar mpileup2cns /projects/b1180/stefanie/PA_phages/bwa/DMS3_WTshort.pileup /
--output-vcf 1 --min-coverage 30 --min-reads2 20 --min-var-freq 0.8 --variants > /
/projects/b1180/stefanie/PA_phages/varscan/DMS3_WTshort_variants.vcf

java -jar VarScan.v2.4.6.jar mpileup2cns /projects/b1180/stefanie/PA_phages/bwa/JG024_9_1short.pileup /
--output-vcf 1 --min-coverage 30 --min-reads2 20 --min-var-freq 0.8 --variants > /
/projects/b1180/stefanie/PA_phages/varscan/JG024_9_1short_variants.vcf

java -jar VarScan.v2.4.6.jar mpileup2cns /projects/b1180/stefanie/PA_phages/bwa/JG024_9_2.pileup --output-vcf 1 --min-coverage 30 --min-reads2 20 --min-var-freq 0.8 --variants > /projects/b1180/stefanie/PA_phages/varscan/JG024_9_2_variants.vcf
```



