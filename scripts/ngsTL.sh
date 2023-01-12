#!/bin/bash

# Estimate TL from a bam or cram file

echo $0
repoDirectory=$(dirname $0)
echo $repoDirectory

cramFile=$1
# cramIndexFile: required
rootOut=$2
gcBedFile=$3

ref=$4
# ref*: needs indx

regionsSearch=$5



# required ... we want to have the option to either run mosdepth, or to use an existing mosdepth file

mosdepthFile=$rootOut.regions.bed.gz

echo "Running mosdepth task"
[ -f "$mosdepthFile" ] || $repoDirectory/mosdepth.sh "$cramFile" "$rootOut" "$ref"

gcStatsFile="$rootOut.ltl.gc.bed.gz"
echo "extracting GC regions task"
$repoDirectory/extractMosdepthGC.sh "$mosdepthFile" "$gcBedFile" "$gcStatsFile"

