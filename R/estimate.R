args = commandArgs(trailingOnly = TRUE)
library(sumsamstats)

# tlCountFile=args[[1]]
# gcStatsFile=args[[2]]
# samtoolsStatsFile=args[[3]]
# kmax=args[[4]]

tlCountFile = "/Users/Kitty/tmp/LTL_tests/NWD883937.ltl.counts.txt.gz"
gcStatsFile = "/Users/Kitty/tmp/LTL_tests/NWD883937.gc.stats.txt.gz"
samtoolsStatsFile = "/Users/Kitty/tmp/LTL_tests/NWD883937.stats.txt.gz"
kmax = 25


tlCounts = read.delim(tlCountFile)
gcStats = read.delim(gcStatsFile)
stats = readLines(samtoolsStatsFile)
readLength = as.numeric(strsplit(stats[grep(pattern = "maximum length", stats)], split = "\t")[[1]][[3]])


computeTLInternalCountMD <- function(df, col, normCol) {
  telCounts = df[, col]
  gcCounts = (df[, normCol] * 1000 * df$mosdepth_gc_n) / df$READ_LENGTH
  rat = telCounts / gcCounts
  scale = 332720800 / 1000 / 46
  tl = rat * scale
  return(tl)
}

tl$LENGTH_ESTIMATE_MD_median = computeTLInternalCountMD(df = tl,
                                                        col = "READS_TOTAL",
                                                        normCol =
                                                          "mosdepth_gc_median")