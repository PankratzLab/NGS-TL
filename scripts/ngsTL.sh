#!/bin/bash

# Estimate TL from a bam or cram file

echo $0
repoDirectory=$(dirname $0)
echo $repoDirectory

cramFile=$1
rootOut=$2
ref=$3
regionsSearch=$4
gcBedFile=$5



$repoDirectory/mosdepth.sh $cramFile $rootOut $ref
