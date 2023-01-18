#!/bin/bash

# Estimate TL from a bam or cram file

echo $0
repoDirectory=$(dirname $0)
echo $repoDirectory

cramFile=$1
craiFile=$2
rootOut=$3
gcBedFile=$4
ref=$5
regionsSearch=$6
mosdepthFile=$7




# required ... we want to have the option to either run mosdepth, or to use an existing mosdepth file
if [ -z "$mosdepthFile" ]
then
    mosdepthFile=$rootOut.regions.bed.gz
    
    echo "Running mosdepth task"
    [ -f "$mosdepthFile" ] || $repoDirectory/scripts/mosdepth.sh "$cramFile" "$rootOut" "$ref"
    
else echo "mosdepthFile is set to '$mosdepthFile'"
fi


gcStatsFile="$rootOut.ltl.gc.stats.txt.gz"
echo "extracting GC regions task"
[ -f "$gcStatsFile" ] || $repoDirectory/scripts/extractMosdepthGC.sh "$mosdepthFile" "$gcBedFile" "$gcStatsFile"

outTLCram="$rootOut.ltl.cram"
samtoolsStatsFile="$outTLCram".stats.txt.gz
echo "extracting ends task"
[ -f "$outTLCram" ] || $repoDirectory/scripts/extractEnds.sh "$cramFile" "$craiFile" "$outTLCram" "$ref" "$regionsSearch"

tlCountFile="$rootOut.ltl.counts.txt.gz"
echo "counting tl reads task"
[ -f "$tlCountFile" ] || $repoDirectory/scripts/countTLReads.sh $outTLCram $tlCountFile


outTLEstimate="$rootOut.ltl.estimate.txt.gz"
echo "estimating tl task"
$repoDirectory/scripts/estimateTL.sh $tlCountFile $gcStatsFile $samtoolsStatsFile $outTLEstimate