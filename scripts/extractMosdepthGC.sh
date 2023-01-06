#!/bin/bash



# summary stats for mosdepth bins overlapping a bed file


set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT


mosdepthFile=$1
mosdepthIndexFile=$2
gcBedFile=$3
gcBedIndexFile=$4
outputFile=$5

vals = as.numeric(readLines ("stdin"))
data.frame(
  min = min(vals),
  max = max(vals),
  mean = mean(vals),
  sd = sd(vals),
  median = median(vals),
  mad = mad(vals),
  iqr = IQR(vals),
  n = n(),
)



bedtools intersect -a $mosdepthFile -b $gcBedFile | cut -f4 |Rscript $rSummary |gzip>$outputFile


library(dplyr)
vals = as.numeric(readLines ("stdin"))
vals = as.data.frame(vals)
vals %>% summarise(
  min = min(vals),
  max = max(vals),
  mean = mean(vals),
  sd = sd(vals),
  median = median(vals),
  mad = mad(vals),
  iqr = IQR(vals),
  n = n(),
)