#!/bin/bash

# Estimate TL from a bam or cram file

options=$(getopt -l "cramFile:,craiFile:,rootOutput:,referenceGenome:,gcBedFile:,regionsSearch:,mosdepthFile:" -o "" -a -- "$@")

eval set -- "$options"

while true
do
    case "$1" in
        -h|--help)
            showHelp
            exit 0
        ;;
        # The cram (or bam) file to process
        --cramFile)
            shift
            export cramFile="$1"
        ;;
        # The cram (or bam) file's index
        --craiFile)
            shift
            export craiFile="$1"
        ;;
        # The root output path (e.g. rootOutput=/path/to/example should result in the creation of /path/to/example.ltl.estimate.txt.gz)
        --rootOutput)
            shift
            export rootOutput="$1"
        ;;
        # The reference genome used to align the cram or bam (e.g. GRCh38_full_analysis_set_plus_decoy_hla.fa)
        --referenceGenome)
            shift
            export referenceGenome="$1"
        ;;
        # Stores 1kb bins that have gc content similar to telomeric repeats.
        # Unless you want to change it, this can be set to https://github.com/PankratzLab/NGS-TL/blob/main/resources/GRCh38_full_analysis_set_plus_decoy_hla.1kb.LTL.GC.filtered.bed.gz
        --gcBedFile)
            shift
            export gcBedFile="$1"
        ;;
        # A bed file defining the regions to look for telomeric reads (typically 25kb from the ends of each chromosome)
        # Unless you want to change it, this can be set to https://github.com/PankratzLab/NGS-TL/blob/main/resources/25kb.bins.bed
        --regionsSearch)
            shift
            export regionsSearch="$1"
        ;;
        # (Optional) If a mosdepth file is provided, mosdepth will not be run.
        # If mosdepth file is not provided, mosdepth will be run to produce $rootOutput.regions.bed.gz
        --mosdepthFile)
            shift
            export mosdepthFile="$1"
        ;;
        --)
            shift
        break;;
    esac
    shift
done

# Parse location of this script so we can reference the helper scripts
repoDirectory=$(dirname $0)
echo "repo directory: $repoDirectory"
echo "cram: $cramFile"
echo "crai: $craiFile"
echo "root output: $rootOutput"
mkdir -p $(dirname $rootOutput)

echo "referenceGenome: $referenceGenome"
echo "gcBedFile: $gcBedFile"
echo "regionsSearch: $regionsSearch"
echo "mosdepthFile: $mosdepthFile"



exit 0



# We want to have the option to either run mosdepth, or to use an existing mosdepth file
if [ -z "$mosdepthFile" ]
then
    # output file of interest
    mosdepthFile=$rootOutput.regions.bed.gz
    
    echo "Running mosdepth task"
    [ -f "$mosdepthFile" ] || $repoDirectory/scripts/mosdepth.sh "$cramFile" "$rootOutput" "$referenceGenome"
    
else echo "mosdepthFile is set to '$mosdepthFile'"
fi

# output file of interest
gcStatsFile="$rootOutput.ltl.gc.stats.txt.gz"
echo "extracting GC regions task"
[ -f "$gcStatsFile" ] || $repoDirectory/scripts/extractMosdepthGC.sh "$mosdepthFile" "$gcBedFile" "$gcStatsFile"

# output file of interest
outTLCram="$rootOutput.ltl.cram"
samtoolsStatsFile="$outTLCram".stats.txt.gz
echo "extracting ends task"
[ -f "$outTLCram" ] || $repoDirectory/scripts/extractEnds.sh "$cramFile" "$craiFile" "$outTLCram" "$referenceGenome" "$regionsSearch"

# output file of interest
tlCountFile="$rootOutput.ltl.counts.txt.gz"
echo "counting tl reads task"
[ -f "$tlCountFile" ] || $repoDirectory/scripts/countTLReads.sh $outTLCram $tlCountFile

# output file of interest
outTLEstimate="$rootOutput.ltl.estimate.txt.gz"
echo "estimating tl task"
$repoDirectory/scripts/estimateTL.sh $tlCountFile $gcStatsFile $samtoolsStatsFile $outTLEstimate