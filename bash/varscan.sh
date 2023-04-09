#!/bin/sh
#SBATCH -A p31750
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 00:30:00
#SBATCH --mem=5gb
#SBATCH --job-name="run_varscan"
#SBATCH --mail-user=stefaniehuttelmaier2024@u.northwestern.edu
#SBATCH --mail-type=ALL
#SBATCH --output=/projects/b1180/stefanie/PA_phages/varscan/varscan.out
#SBATCH --error=/projects/b1180/stefanie/PA_phages/varscan/varscan.err


#script to run varscan at different parameters
#assumes you have already aligned using bwa and have sorted input required by varscan

module purge all
module load java

min_cov=30
min_reads=20
min_var_freq=0.50
min_var_freq_filename=50

mpileup=`ls /projects/b1180/stefanie/PA_phages/bwa | grep .pileup"" | sed 's/\.[^.]*$//'`


 for input in ${mpileup}
    do java -jar /projects/b1180/software/VarScan.v2.4.6.jar mpileup2cns /projects/b1180/stefanie/PA_phages/bwa/${input}.pileup --output-vcf 1 --min-coverage ${min_cov} --min-reads2 ${min_reads} --min-var-freq ${min_var_freq} --variants > /projects/b1180/stefanie/PA_phages/varscan/${input}_variants.${min_var_freq_filename}.vcf
done
