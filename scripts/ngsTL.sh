#!/bin/bash

# Estimate TL from a bam or cram file

echo $0
repoDirectory=$(dirname $0)
echo $repoDirectory

cramFile=$1
# cramIndexFile: required
rootOut=$2
ref=$3
# ref*: needs indx
regionsSearch=$4
gcBedFile=$5



# required ... we want to have the option to either run mosdepth, or to use an existing mosdepth file

mosdepthFile=$rootOut.regions.bed.gz

echo "Running mosdepth task"
[ -f "$mosdepthFile" ] || $repoDirectory/mosdepth.sh "$cramFile" "$rootOut" "$ref"

echo "extracting GC regions task"
$repoDirectory/extractMosdepthGC.sh "$mosdepthFile" "$mosdepthIndexFile" "$gcBedFile" "$rootOut.ltl.gz.bed.gz"

