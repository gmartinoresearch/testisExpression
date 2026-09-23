#!/bin/bash
#SBATCH --job-name refineRevio
#SBATCH --cpus-per-task 40
#SBATCH --mem 300gb
#SBATCH --time 72:00:00
#SBATCH -o refineRevio.out


FILES=/project/mkonkel/tangeno/users/giannim/chrY/extraSamples/originalFiles/convertedBams/*.bam
for f in $FILES
do
	#echo "$f"
	FILENAME=$(echo "$f" | awk -F"/" '{print $11}' | awk -F".bam" '{print $1}')
	#echo "$FILENAME"
	/home/giannim/miniconda/envs/isoseq/bin/isoseq refine --require-polya "$f" /project/mkonkel/tangeno/users/giannim/revio/IsoSeq_v2_primers_12.fasta /project/mkonkel/tangeno/users/giannim/chrY/extraSamples/refined/"$FILENAME"_trimmed.bam
done
