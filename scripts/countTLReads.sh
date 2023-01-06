#!/bin/bash



# Extract reads from a specified bed file
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT


cramFile=$1
craiFile=$2
outCram=$3
ref=$4
regionsSearch=$5



    ks=($(seq 1 1 20))
    for k in "${ks[@]}"; do
        echo "hi $k"
        
        outFileFilter=$(echo "$4"| sed s/.cram/.LTL/g)
        outFileFilter="$outFileFilter".k.$k.stats.txt.gz
        if [ ! -f "$outFileFilter" ]
        
        then
            echo "$outFileFilter"
            samtools view -h $outFile \
            | awk -v OFS='\t'  -v readIndex=10 -v k=$k  '{if(gsub(/CCCTAA/, "CCCTAA",$readIndex) >= k || gsub(/TTAGGG/, "TTAGGG",$readIndex) >=k || /@/){print $0}}' \
            | samtools stats |gzip > "$outFileFilter"
            
            
            
        else
            echo "skipping parsing of "$outFileFilter" "
        fi
    done