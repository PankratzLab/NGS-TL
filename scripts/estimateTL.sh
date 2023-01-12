#!/bin/bash

# Estimate TL using gc stats file and tl count file

tlCountFile=$1
gcStatsFile=$2
samtoolsStatsFile=$3
output=$4

Rscript $(dirname $0)/../R/estimate.R $tlCountFile $gcStatsFile $samtoolsStatsFile $output