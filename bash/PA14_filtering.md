
##Load modules
```
module load bwa
module load samtool
module load bed tools
```

##long read alignment to DMS3 reference gemone  
Aligning to host PA14 genome to remove contamination  
Note: reference must be indexed first using bwa index  
```
bwa mem /projects/b1180/stefanie/PA_phages/PA14_ref/PA14.fasta /projects/b1180/reads/PA_phages/longread/DMS3_WTlong_nanopore.fastq > DMS3_WTlong.aligned.sam
```

##Convert output sam to bam
```
samtools view -Subh -o DMS3_WTlong.aligned.bam DMS3_WTlong.aligned.sam

```

##Sort bam by location
```
samtools sort -o DMS3_WTlong.sorted.aligned.bam DMS3_WTlong.aligned.bam
```

##Filter unmapped reads (these are the reads we want)
```
samtools view -b -f 12 -F 256 -o DMS3_WTlong.unmapped.bam DMS3_WTlong.sorted.aligned.bam
```

##convert unmapped long read file back to fq.gz for downstream analysis
```
bedtools bamtofastq -i DMS3_WTlong.unmapped.bam -fq DMS3_WTlong_clean.fq.gz
```
