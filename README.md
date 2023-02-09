# NGS-TL
Estimate telomere length (TL) from whole genome sequencing



## Example usage (via singularity)

Primary entry point is to run [ngsTL.sh](https://github.com/PankratzLab/NGS-TL/blob/main/ngsTL.sh) that is inside the docker image (https://quay.io/repository/jlanej/ngs-tl?tab=info) 


```

singularity run \
...
"docker://quay.io/jlanej/ngs-tl" \
/app/NGS-TL/ngsTL.sh \
# The cram (or bam) file to process
--cramFile "$cramFile" \
# The cram (or bam) file's index
--craiFile "$craiFile" \
# The root output path (e.g. rootOutput=/path/to/example should result in the creation of /path/to/example.ltl.estimate.txt.gz)
--rootOutput "$rootOutput" \
# The reference genome used to align the cram or bam (e.g. GRCh38_full_analysis_set_plus_decoy_hla.fa)
--referenceGenome "$referenceGenome" \
# Stores 1kb bins that have gc content similar to telomeric repeats.
# Unless you want to change it, this can be set to https://github.com/PankratzLab/NGS-TL/blob/main/resources/GRCh38_full_analysis_set_plus_decoy_hla.1kb.LTL.GC.filtered.bed.gz
--gcBedFile "$gcBedFile" \
# A bed file defining the regions to look for telomeric reads (typically 25kb from the ends of each chromosome)
# Unless you want to change it, this can be set to https://github.com/PankratzLab/NGS-TL/blob/main/resources/25kb.bins.bed
--regionsSearch "$regionsSearch"



# (Optional) If a mosdepth file is provided, mosdepth will not be run.
# If mosdepth file is not provided, mosdepth will be run to produce $rootOutput.regions.bed.gz
#--mosdepthFile $pathToMosdepthFil
```

A parameterized example with all expected output can be found in the [example directory](https://github.com/PankratzLab/NGS-TL/tree/main/example) of this repo. Output was generated using [example.sh](https://github.com/PankratzLab/NGS-TL/tree/main/example/example.sh)


## Output

The primary output of interest is a file named "$rootOutput".ltl.estimate.txt.gz (e.g. https://github.com/PankratzLab/NGS-TL/blob/main/example/NA12878.ltl.estimate.txt.gz). 

| mosdepth_gc_coverage_min | mosdepth_gc_coverage_max | mosdepth_gc_coverage_mean | mosdepth_gc_coverage_sd | mosdepth_gc_coverage_median | mosdepth_gc_coverage_mad | mosdepth_gc_coverage_iqr | mosdepth_gc_coverage_n | READ_LENGTH | TL_READS_AT_K_1 | LENGTH_ESTIMATE_AT_K_1 | TL_READS_AT_K_2 | LENGTH_ESTIMATE_AT_K_2 | TL_READS_AT_K_3 | LENGTH_ESTIMATE_AT_K_3 | TL_READS_AT_K_4 | LENGTH_ESTIMATE_AT_K_4 | TL_READS_AT_K_5 | LENGTH_ESTIMATE_AT_K_5 | TL_READS_AT_K_6 | LENGTH_ESTIMATE_AT_K_6 | TL_READS_AT_K_7 | LENGTH_ESTIMATE_AT_K_7 | TL_READS_AT_K_8 | LENGTH_ESTIMATE_AT_K_8 | TL_READS_AT_K_9 | LENGTH_ESTIMATE_AT_K_9 | TL_READS_AT_K_10 | LENGTH_ESTIMATE_AT_K_10 | TL_READS_AT_K_11 | LENGTH_ESTIMATE_AT_K_11 | TL_READS_AT_K_12 | LENGTH_ESTIMATE_AT_K_12 | TL_READS_AT_K_13 | LENGTH_ESTIMATE_AT_K_13 | TL_READS_AT_K_14 | LENGTH_ESTIMATE_AT_K_14 | TL_READS_AT_K_15 | LENGTH_ESTIMATE_AT_K_15 | TL_READS_AT_K_16 | LENGTH_ESTIMATE_AT_K_16 |
|--------------------------|--------------------------|---------------------------|-------------------------|-----------------------------|--------------------------|--------------------------|------------------------|-------------|-----------------|------------------------|-----------------|------------------------|-----------------|------------------------|-----------------|------------------------|-----------------|------------------------|-----------------|------------------------|-----------------|------------------------|-----------------|------------------------|-----------------|------------------------|------------------|-------------------------|------------------|-------------------------|------------------|-------------------------|------------------|-------------------------|------------------|-------------------------|------------------|-------------------------|------------------|-------------------------|
| 0                        | 126.56                   | 4.835327                  | 2.169083                | 4.87                        | 1.082298                 | 1.47                     | 24563                  | 101         | 16421           | 101.00336363383        | 15285           | 94.0159803387793       | 15140           | 93.1241048301681       | 15014           | 92.3490957675128       | 14846           | 91.315750350639        | 14657           | 90.1532367566561       | 14419           | 88.6893307494183       | 14175           | 87.1885195487207       | 13880           | 85.3740142036151       | 13522            | 83.1720043271818        | 13094            | 80.5394338603844        | 12610            | 77.5624149212959        | 11986            | 73.7242748014791        | 11280            | 69.3817637043788        | 10227            | 62.9049022521882        | 8087             | 49.7420499182014        |
|                          |                          |                           |                         |                             |                          |                          |                        |             |                 |                        |                 |                        |                 |                        |                 |                        |                 |                        |                 |                        |                 |                        |                 |                        |                 |                        |                  |                         |                  |                         |                  |                         |                  |                         |                  |                         |                  |                         |                  |                         |
|                          |                          |                           |                         |                             |                          |                          |                        |             |                 |                        |                 |                        |                 |                        |                 |                        |                 |                        |                 |                        |                 |                        |                 |                        |                 |                        |                  |                         |                  |                         |                  |                         |                  |                         |                  |                         |                  |                         |                  |                         |



Brief data dictionary of the results:

| Column                      | Description                                                                                                            |   |
|-----------------------------|------------------------------------------------------------------------------------------------------------------------|---|
| mosdepth_gc_coverage_min    | The minimum coverage of the 1kb mosdepth bins that overlap the gcBedFile                                               |   |
| mosdepth_gc_coverage_max    | The max coverage of the 1kb mosdepth bins that overlap the gcBedFile                                                   |   |
| mosdepth_gc_coverage_mean   | The mean coverage of the 1kb mosdepth bins that overlap the gcBedFile. Currently, this value is used for normalization |   |
| mosdepth_gc_coverage_sd     | The sd of the coverage of the 1kb mosdepth bins that overlap the gcBedFile                                             |   |
| mosdepth_gc_coverage_median | The median coverage of the 1kb mosdepth bins that overlap the gcBedFile                                                |   |
| mosdepth_gc_coverage_mad    | The mad of the coverage of the 1kb mosdepth bins that overlap the gcBedFile                                            |   |
| mosdepth_gc_coverage_iqr    | The iqr of the coverage of the 1kb mosdepth bins that overlap the gcBedFile                                            |   |
| mosdepth_gc_coverage_n      | The number of 1kb mosdepth bins that overlap the gcBedFile                                                             |   |
| READ_LENGTH                 | Empircially determined read length of the bam (max read length reported by samtools stats)                             |   |
| TL_READS_AT_K_1             | Number of reads containing at least 1 telomric repeat                                                                  |   |
| LENGTH_ESTIMATE_AT_K_1      | TL estimate using a repeat "K" threshold of 1                                                                          |   |
| TL_READS_AT_K_2             | Number of reads containing at least 1 telomric repeats                                                                 |   |
| LENGTH_ESTIMATE_AT_K_2      | TL estimate using a repeat "K" threshold of 2                                                                          |   |
| …                           | …                                                                                                                      |   |
| TL_READS_AT_K_N             | Number of reads containing at least N telomric repeats                                                                 |   |
| LENGTH_ESTIMATE_AT_K_N      | TL estimate using a repeat "K" threshold of N                                                                          |   |
