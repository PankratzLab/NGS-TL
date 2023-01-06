#!/bin/bash



# Count telomeric content in reads


set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT


cramFile=$1
craiFile=$2
outFileRoot=$3


samtools view -h $cramFile \
| awk -v OFS='\t'  -v readIndex=10 -v k=$k  '{k1=gsub(/CCCTAA/, "CCCTAA",$readIndex);k2=gsub(/TTAGGG/, "TTAGGG",$readIndex)}{if(k1 >= k2){print k1} else {print k2}}'

