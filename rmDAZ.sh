#!/bin/bash
#SBATCH --job-name DAZrm
#SBATCH --cpus-per-task 4
#SBATCH --mem 64gb
#SBATCH --time 72:00:00

mkdir /project/mkonkel/tangeno/users/giannim/chrY/exonRepeatmasker/DAZ/DAZrepeatOut_v3/pooledTestis/
mkdir /project/mkonkel/tangeno/users/giannim/chrY/exonRepeatmasker/DAZ/DAZrepeatOut_v3/gencode/
/project/mkonkel/tangeno/pkg/mcl/CustomLibraryRepeatMasker/share/RepeatMasker/RepeatMasker_TMP -s \
            -pa 4 \
            -dir  "/project/mkonkel/tangeno/users/giannim/chrY/exonRepeatmasker/DAZ/DAZrepeatOut_v3/pooledTestis/" \
            -lib "/project/mkonkel/tangeno/users/giannim/chrY/geneSequences_v2/DAZ.fasta" \
            "/project/mkonkel/tangeno/users/giannim/chrY/geneFamilyReads/testis/merged/DAZ_mergedReads.fa"
            
/project/mkonkel/tangeno/pkg/mcl/CustomLibraryRepeatMasker/share/RepeatMasker/RepeatMasker_TMP -s \
            -pa 4 \
            -dir  "/project/mkonkel/tangeno/users/giannim/chrY/exonRepeatmasker/DAZ/DAZrepeatOut_v3/gencode/" \
            -lib "/project/mkonkel/tangeno/users/giannim/chrY/geneSequences_v2/DAZ.fasta" \
            "/project/mkonkel/tangeno/users/giannim/chrY/geneFamilyReads/gencodeTestis/merged/DAZ_mergedReads.fa"