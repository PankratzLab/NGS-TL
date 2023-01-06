#!/bin/bash



# Count telomeric content in reads


set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT


cramFile=$1
craiFile=$2
outputFile=$3


cramFile=/Volumes/Beta2/NGS/topmed/MICA/anvil_terra/bams_BDC_LTL/NWD276796.b38.irc.v1.LTL.bam
outputFile=/Users/Kitty/tmp/test.txt.gz

sample=$(samtools samples $cramFile)

awk -v OFS='\t' 'BEGIN {print "Count","RepeatK","Sample","Cram"}' |gzip> $outputFile


samtools view -h $cramFile \
| awk -v OFS='\t'  -v readIndex=10 \
'{k1=gsub(/CCCTAA/, "CCCTAA",$readIndex);k2=gsub(/TTAGGG/, "TTAGGG",$readIndex)}{if(k1 >= k2){print k1} else {print k2}}' \
|sort |uniq -c |awk -v sample=$sample -v OFS='\t' -v IFS=' ' '{print $1,$2,sample}' |gzip >> $outputFile

