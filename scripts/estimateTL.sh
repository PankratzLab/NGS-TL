#!/bin/bash

# Estimate TL using gc stats file and tl count file

tlCountFile=$1
gcStatsFile=$2
samtoolsStatsFile=$3
output=$4


echo $0
repoDirectory=$(dirname $0)
echo $repoDirectory

Rscript ../R/estimate.R $tlCountFile $gcStatsFile $samtoolsStatsFile