
module load bedtools
module load R
module load samtools/1.14

gcBedFile=/home/pankrat2/public/bin/ref/GRCh38_full_analysis_set_plus_decoy_hla.1kb.LTL.GC.filtered.bed.gz
mosdepthFile=/scratch.global/lanej/topMed/mosdepth.all/data/mosdepth/broad/WHI/NWD883937/NWD883937.by1000.regions.bed.gz
outputFile=/home/tsaim/lane0212/tmp/LTL_tests/NWD883937.gc.stats.txt.gz


bamOrCram=/scratch.global/lanej/topMed/LTL/experimental/bams_BDC_LTL_V2/NWD883937.b38.irc.v1.LTL.bam
outputFile=/home/tsaim/lane0212/tmp/LTL_tests/NWD883937.ltl.counts.txt.gz



tlCountFile = "/Users/Kitty/tmp/LTL_tests/NWD883937.ltl.counts.txt.gz"
gcStatsFile = "/Users/Kitty/tmp/LTL_tests/NWD883937.gc.stats.txt.gz"
samtoolsStatsFile = "/Users/Kitty/tmp/LTL_tests/NWD883937.stats.txt.gz"
kmax = 25
output="/Users/Kitty/tmp/LTL_tests/NWD883937.estimate.txt.gz"