#!/bin/bash

# Estimate TL from a bam or cram file

echo $0
repoDirectory=$(dirname $0)
echo $repoDirectory

cramFile=$1
craiFile=$2
outCram=$3
ref=$4
regionsSearch=$5
rootOut=$6
mosdepthFile=$1
mosdepthIndexFile=$2
gcBedFile=$3
gcBedIndexFile=$4
outputFile=$5