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



$repoDirectory/mosdepth.sh $cramFile $rootOut $ref

# required output 
mosdepthFile=$rootOut.regions.bed.gz
mosdepthIndexFile=$rootOut.regions.bed.csi

$repoDirectory/extractMosdepthGC.sh $mosdepthFile $mosdepthIndexFile $gcBedFile $rootOut.ltl.gz.bed.gz

