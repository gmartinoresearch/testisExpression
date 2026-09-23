#!/bin/bash
#SBATCH --job-name mapReads
#SBATCH --cpus-per-task 40
#SBATCH --mem 300gb
#SBATCH --time 72:00:00


FILES=/project/mkonkel/tangeno/users/giannim/chrY/extraSamples/maleGeneReads/RBMY_TSPY_DAZ_gencodeReads*.fasta
for f in $FILES
do
  FILENAME=$(echo "$f" | awk -F"/" '{print $10}' | awk -F"." '{print $1}')
  
  /home/giannim/miniconda/envs/pbmm2/bin/pbmm2 align "/project/mkonkel/tangeno/users/giannim/referenceGenomes/chm13_ncbi/data/GCF_009914755.1/GCF_009914755.1_T2T-CHM13v2.0_genomic_chrY.fa" "$f" /project/mkonkel/tangeno/users/giannim/chrY/expressionFigureAlignments/alignments/"$FILENAME".bam --preset ISOSEQ --sort
  
done