#!/bin/bash

# Estimate TL using gc stats file and tl count file

tlCountFile=$1
gcStatsFile=$2

Rscript ../R/estimate.R $tlCountFile $gcStatsFile