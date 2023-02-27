#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mem=20gb
#SBATCH -t 74:00:00
#SBATCH --mail-type=ALL
#SBATCH -p pankratz
#SBATCH -o %j.out
#SBATCH -e %j.err

module load parallel

# Estimate LTL on all 1000G high coverage crams, via slrm and singularity



# causes a script to immediately exit when it encounters an error.
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

# set up directory with resources
processDir=$HOME/tmp/ngs_tl_example_1000G/
mkdir -p "$processDir"
cd "$processDir"

regionsSearch="$processDir"/25kb.bins.bed
[ -f "$regionsSearch" ] || wget https://raw.githubusercontent.com/PankratzLab/NGS-TL/main/resources/25kb.bins.bed

gcBedFile="$processDir"/GRCh38_full_analysis_set_plus_decoy_hla.1kb.LTL.GC.filtered.bed.gz
[ -f "$gcBedFile" ] || wget https://raw.githubusercontent.com/PankratzLab/NGS-TL/main/resources/GRCh38_full_analysis_set_plus_decoy_hla.1kb.LTL.GC.filtered.bed.gz

referenceGenome="$processDir"/GRCh38_full_analysis_set_plus_decoy_hla.fa
[ -f "$referenceGenome" ] || wget "ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa"


seqIndex="$processDir"/1000G_2504_high_coverage.sequence.index

[ -f "$seqIndex" ] ||wget "http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/1000G_2504_high_coverage.sequence.index"


grep -v "#" $seqIndex |cut -f1 \
|head -n100 \
| parallel -j1 "echo {.}.cram; echo $processDir/{/.}"

apptainer pull docker://ghcr.io/pankratzlab/ngs-tl:main 

apptainer --debug  run \
--bind $processDir \
docker://ghcr.io/pankratzlab/ngs-tl:main \
/app/NGS-TL/ngsTL.sh \
--cramFile ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR323/ERR3239490/NA12890.final.cram \
--craiFile ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR323/ERR3239490/NA12890.final.cram.crai \
--rootOutput $processDir/NA12890.final \
--referenceGenome $referenceGenome \
--gcBedFile $gcBedFile \
--regionsSearch $regionsSearch

grep -v "#" $seqIndex |cut -f1 \
|head -n100 \
| parallel -j1 "echo {.}.cram; \
 apptainer run \
--bind $processDir \
docker://ghcr.io/pankratzlab/ngs-tl:main \
/app/NGS-TL/ngsTL.sh \
--cramFile {} \
--craiFile {}.crai \
--rootOutput $processDir/{/.} \
--referenceGenome $referenceGenome \
--gcBedFile $gcBedFile \
--regionsSearch $regionsSearch"
