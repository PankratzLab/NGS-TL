#!/bin/bash

# summary stats for mosdepth bins overlapping a bed file
mosdepthFile=$1
mosdepthIndexFile=$2
gcBedFile=$3
gcBedIndexFile=$4
outputFile=$5

summarizeScript='vals = as.numeric(readLines ("stdin"))'
bedtools intersect -a $mosdepthFile -b $gcBedFile | cut -f4 |Rscript -e 'vals = as.numeric(readLines ("stdin"));data.frame(min = min(vals),max = max(vals),mean = mean(vals),sd = sd(vals),median = median(vals),mad = mad(vals),iqr = IQR(vals),n = length(vals))' \
|gzip>$outputFile