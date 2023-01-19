#!/bin/bash

# Estimate TL from a bam or cram file


# Parse location of this script so we can reference the helper scripts
echo $0
repoDirectory=$(dirname $0)
echo $repoDirectory

# The cram (or bam) file to process
cramFile=$1
# The cram (or bam) file's index
craiFile=$2
# The root output path (e.g. rootOut=/path/to/example should result in the creation of /path/to/example.ltl.estimate.txt.gz)
rootOut=$3
# Stores 1kb bins that have gc content similar to telomeric repeats. 
# Unless you want to change it, this can be set to https://github.com/PankratzLab/NGS-TL/blob/main/resources/GRCh38_full_analysis_set_plus_decoy_hla.1kb.LTL.GC.filtered.bed.gz
gcBedFile=$4
# The reference genome used to align the cram or bam (e.g. GRCh38_full_analysis_set_plus_decoy_hla.fa)
ref=$5
# A bed file defining the regions to look for telomeric reads (typically 25kb from the ends of each chromosome)
# Unless you want to change it, this can be set to https://github.com/PankratzLab/NGS-TL/blob/main/resources/25kb.bins.bed
regionsSearch=$6
# (Optional) If a mosdepth file is provided, mosdepth will not be run.
# If mosdepth file is not provided, mosdepth will be run to produce $rootOut.regions.bed.gz
mosdepthFile=$7




# We want to have the option to either run mosdepth, or to use an existing mosdepth file
if [ -z "$mosdepthFile" ]
then
    # output file of interest
    mosdepthFile=$rootOut.regions.bed.gz
    
    echo "Running mosdepth task"
    [ -f "$mosdepthFile" ] || $repoDirectory/scripts/mosdepth.sh "$cramFile" "$rootOut" "$ref"
    
else echo "mosdepthFile is set to '$mosdepthFile'"
fi

# output file of interest
gcStatsFile="$rootOut.ltl.gc.stats.txt.gz"
echo "extracting GC regions task"
[ -f "$gcStatsFile" ] || $repoDirectory/scripts/extractMosdepthGC.sh "$mosdepthFile" "$gcBedFile" "$gcStatsFile"

# output file of interest
outTLCram="$rootOut.ltl.cram"
samtoolsStatsFile="$outTLCram".stats.txt.gz
echo "extracting ends task"
[ -f "$outTLCram" ] || $repoDirectory/scripts/extractEnds.sh "$cramFile" "$craiFile" "$outTLCram" "$ref" "$regionsSearch"

# output file of interest
tlCountFile="$rootOut.ltl.counts.txt.gz"
echo "counting tl reads task"
[ -f "$tlCountFile" ] || $repoDirectory/scripts/countTLReads.sh $outTLCram $tlCountFile

# output file of interest
outTLEstimate="$rootOut.ltl.estimate.txt.gz"
echo "estimating tl task"
$repoDirectory/scripts/estimateTL.sh $tlCountFile $gcStatsFile $samtoolsStatsFile $outTLEstimate