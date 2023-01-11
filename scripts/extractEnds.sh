#!/bin/bash

# Extract reads from a specified bed file
cramFile=$1
craiFile=$2
outCram=$3
ref=$4
regionsSearch=$5



echo "extracting regions defined by $regionsSearch from $cramFile to $outCram"
# If we do not add the perl portion, -X to specify the crai gets angry when reading from amazon or google buckets.
# Typically samtools is able to extract regions defined by a bed file, but doesn't like to do so from cloud sources (or I had specified something incorrectly)

samtools view -b -o "$outCram" -X --reference $ref -M -L "$regionsSearch" -h "$cramFile" "$craiFile" $(perl -ane '{print "$F[0]:$F[1]-$F[2] "}' $regionsSearch )
samtools index "$outCram"

echo "running samtools stats on $outCram"

samtools stats "$outCram" |gzip > "$outCram".stats.txt.gz