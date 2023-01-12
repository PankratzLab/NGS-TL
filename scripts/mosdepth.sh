#!/bin/bash

# Run mosdepth


cramFile=$1
outRoot=$2
ref=$3

/usr/local/bin/mosdepth -n -t 1 --by 1000 --fasta "$ref" "$outRoot" "$cramFile"