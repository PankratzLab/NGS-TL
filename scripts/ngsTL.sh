#!/bin/bash

# Estimate TL from a bam or cram file

echo $0
repoDirectory=$(dirname $0)
echo $repoDirectory

cramFile=$1
craiFile=$2
rootOut=$3

#resources
gcBedFile=$4

ref=$5
# ref*: needs indx

regionsSearch=$6



# required ... we want to have the option to either run mosdepth, or to use an existing mosdepth file

mosdepthFile=$rootOut.regions.bed.gz

echo "Running mosdepth task"
[ -f "$mosdepthFile" ] || $repoDirectory/mosdepth.sh "$cramFile" "$rootOut" "$ref"

gcStatsFile="$rootOut.ltl.gc.stats.txt.gz"
echo "extracting GC regions task"
[ -f "$gcStatsFile" ] || $repoDirectory/extractMosdepthGC.sh "$mosdepthFile" "$gcBedFile" "$gcStatsFile"

outTLCram="$rootOut.ltl.cram"
samtoolsStatsFile="$outTLCram".stats.txt.gz
echo "extracting ends task"
[ -f "$outTLCram" ] || $repoDirectory/extractEnds.sh "$cramFile" "$craiFile" "$outTLCram" "$ref" "$regionsSearch"

tlCountFile="$rootOut.ltl.counts.txt.gz"
echo "counting tl reads task"
$repoDirectory/countTLReads.sh $outTLCram $tlCountFile


outTLEstimate="$rootOut.ltl.estimate.txt.gz"
echo "estimating tl task"
$repoDirectory/estimateTL.sh $tlCountFile $gcStatsFile $samtoolsStatsFile $outTLEstimate