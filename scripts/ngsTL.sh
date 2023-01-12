#!/bin/bash

# Estimate TL from a bam or cram file

echo $0
repoDirectory=$(dirname $0)
echo $repoDirectory

cramFile=$1
cramIndexFile $2
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

gcStatsFile="$rootOut.ltl.gc.bed.gz"
echo "extracting GC regions task"
[ -f "$gcStatsFile" ] || $repoDirectory/extractMosdepthGC.sh "$mosdepthFile" "$gcBedFile" "$gcStatsFile"

outTLCram="$rootOut.ltl.cram"
$repoDirectory/extractEnds.sh "$cramFile" "$cramIndexFile" "$outTLCram" "$ref" "$regionsSearch"