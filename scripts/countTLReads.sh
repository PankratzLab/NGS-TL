#!/bin/bash



# Extract reads matching telomeric content
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT


cramFile=$1
craiFile=$2
outFileRoot=$3
kMin=$4
kMax=$5



ks=($(seq $kmin 1 $kMax))

for k in "${ks[@]}"; do
    echo "parsing count for $k"
    
    outFileFilter="$outFileRoot".k.$k.stats.txt.gz
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