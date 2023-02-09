#!/bin/bash

# causes a script to immediately exit when it encounters an error.
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

# set up directory with resources
processDir=$HOME/tmp/ngs_tl_example/
mkdir -p "$processDir"
cd "$processDir"

wget https://github.com/PankratzLab/NGS-TL/blob/main/resources/25kb.bins.bed
regionsSearch="$processDir"/25kb.bins.bed

wget https://github.com/PankratzLab/NGS-TL/blob/main/resources/GRCh38_full_analysis_set_plus_decoy_hla.1kb.LTL.GC.filtered.bed.gz
gcBedFile="$processDir"/GRCh38_full_analysis_set_plus_decoy_hla.1kb.LTL.GC.filtered.bed.gz

wget "ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa"
referenceGenome="$processDir"/GRCh38_full_analysis_set_plus_decoy_hla.fa


# use 1000G sample to test
cramFile="ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000_genomes_project/data/CEU/NA12878/alignment/NA12878.alt_bwamem_GRCh38DH.20150718.CEU.low_coverage.cram"
craiFile="ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000_genomes_project/data/CEU/NA12878/alignment/NA12878.alt_bwamem_GRCh38DH.20150718.CEU.low_coverage.cram.crai"


rootOut="$processDir"/NA12878


# INSTALL singularity 

singularity run \
--bind "$processDir" \
$singularityImage \
/app/NGS-TL/ngsTL.sh \
--cramFile "$cramFile" \
--craiFile "$craiFile" \
--rootOutput "$rootOut" \
--referenceGenome "$referenceGenome" \
--gcBedFile "$gcBedFile" \
--regionsSearch "$regionsSearch"



