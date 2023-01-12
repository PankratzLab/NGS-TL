#!/bin/bash

# Run mosdepth


cramOrBamFile=$1
outRoot=$2
ref=$3

mosdepth -n -t 1 --by 1000 --fasta "$ref" "$outRoot" "$cramOrBamFile"