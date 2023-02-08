# NGS-TL
Estimate telomere length (TL) from whole genome sequencing


## Example usage

```
ngsTL.sh \
--cramFile "$cramFile" \
--craiFile "$craiFile" \
--rootOutput "$rootOut" \
--referenceGenome "$referenceGenome" \
--gcBedFile "$gcBedFile" \
--regionsSearch "$regionsSearch"
```

## Example usage (via singularity)

```

singularity run \
...
"docker://quay.io/jlanej/ngs-tl" \
/app/NGS-TL/ngsTL.sh \
--cramFile "$cramFile" \
--craiFile "$craiFile" \
--rootOutput "$rootOut" \
--referenceGenome "$referenceGenome" \
--gcBedFile "$gcBedFile" \
--regionsSearch "$regionsSearch"
```
