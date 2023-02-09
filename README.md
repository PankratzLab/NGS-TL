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
