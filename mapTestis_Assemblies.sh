#!/bin/bash
#SBATCH --job-name maleMap1
#SBATCH --cpus-per-task 40
#SBATCH --mem 300gb
#SBATCH --time 72:00:00


FILES=/project/mkonkel/tangeno/forMark/chrY/*.fa

for f in $FILES
do
  FILENAME=$(echo "$f" | awk -F"/" '{print $7}' | awk -F"_chrY.fa" '{print $1}')
  
  /home/giannim/miniconda/envs/pbmm2/bin/pbmm2 align "$f" "/project/mkonkel/tangeno/users/giannim/chrY/extraSamples/maleGeneReads/RBMY_TSPY_DAZ_gencodeReads.fasta" /project/mkonkel/tangeno/users/giannim/chrY/extraSamples/mappedAssembly/allAssemblies/maleGeneReads_"$FILENAME"chrY.bam --preset ISOSEQ --sort
  
done 
