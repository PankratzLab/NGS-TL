#!/bin/bash

# Count telomeric content in non secondary, non supplemental alignments from a bam or cram

bamOrCram=$1
outputFile=$2

sample=$(samtools samples $bamOrCram)

awk -v OFS='\t' 'BEGIN {print "Count","RepeatK","Sample","Cram"}' |gzip> $outputFile

samtools view -h -F 0x900 $bamOrCram \
| awk -v OFS='\t'  -v readIndex=10 \
'{k1=gsub(/CCCTAA/, "CCCTAA",$readIndex);k2=gsub(/TTAGGG/, "TTAGGG",$readIndex)}{if(k1 >= k2){print k1} else {print k2}}' \
|sort |uniq -c |awk -v sample="$sample" -v OFS='\t' -v IFS=' ' '{print $1,$2,sample}'|sort -k 2 -n |gzip >> $outputFile

