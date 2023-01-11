args = commandArgs(trailingOnly = TRUE)

# tlCountFile=args[[1]]
# gcStatsFile=args[[2]]
k = args[[3]]
tlCountFile = "/Users/Kitty/tmp/LTL_tests/NWD883937.ltl.counts.txt.gz"
gcStatsFile = "/Users/Kitty/tmp/LTL_tests/NWD883937.gc.stats.txt.gz"
k = 9


tlCounts = read.delim(tlCountFile)

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