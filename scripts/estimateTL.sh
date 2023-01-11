#!/bin/bash

# Estimate TL using gc stats file and tl count file

tlCountFile=$1
gcStatsFile=$2

tlCountFile=/Users/Kitty/tmp/LTL_tests/NWD883937.ltl.counts.txt.gz
gcStatsFile=/Users/Kitty/tmp/LTL_tests/NWD883937.gc.stats.txt.gz


Rscript ../R/estimate.R $tlCountFile $gcStatsFile