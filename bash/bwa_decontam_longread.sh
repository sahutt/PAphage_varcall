
#!/bin/sh
#SBATCH -A p31750
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH --mem=15gb
#SBATCH --job-name="run_bwa_decontam"
#SBATCH --mail-user=stefaniehuttelmaier2024@u.northwestern.edu
#SBATCH --mail-type=ALL
#SBATCH --output=/projects/b1180/stefanie/PA_phages/longread/bwa/bwa_decontam.out
#SBATCH --error=/projects/b1180/stefanie/PA_phages/longread/bwa/bwa_decontam.err


#purge potential conflicting modules
module purge all

#load dependencies
module load bwa
module load samtools
module load bedtools

##long read alignment  
#Aligning to host PA14 genome to remove contamination  
#Note: reference must be indexed first using bwa index  

#alignment with bwa
bwa mem /projects/b1180/stefanie/PA_phages/PA14_ref/PA14.fasta /projects/b1180/reads/PA_phages/longread/DMS3_WTlong_nanopore.fastq > /projects/b1180/stefanie/PA_phages/longread/bwa/DMS3_WTlong.aligned.sam
bwa mem /projects/b1180/stefanie/PA_phages/PA14_ref/PA14.fasta /projects/b1180/reads/PA_phages/longread/JG024_9_1long_nanopore.fastq.gz > /projects/b1180/stefanie/PA_phages/longread/bwa/JG024_9_1long.aligned.sam

#change to bwa output directory
cd /projects/b1180/stefanie/PA_phages/longread/bwa

#convert sam to bam
samtools view -Subh -o DMS3_WTlong.aligned.bam DMS3_WTlong.aligned.sam
samtools view -Subh -o JG024_9_1long.aligned.bam JG024_9_1long.aligned.sam

#sort bam file by read location on ref
samtools sort -o DMS3_WTlong.sorted.aligned.bam DMS3_WTlong.aligned.bam
samtools sort -o JG024_9_1long.sorted.aligned.bam JG024_9_1long.aligned.bam

#filter out reads that did not map to host, which is what we want
samtools view -b -f 4 -o DMS3_WTlong.unmapped.bam DMS3_WTlong.sorted.aligned.bam
samtools view -b -f 4 -o JG024_9_1long.unmapped.bam JG024_9_1long.sorted.aligned.bam

#convert unmapped reads back into fastq file for downstream analysis
bedtools bamtofastq -i DMS3_WTlong.unmapped.bam -fq DMS3_WTlong_clean.fq.gz
bedtools bamtofastq -i JG024_9_1long.unmapped.bam -fq JG024_9_1long.fq.gz


