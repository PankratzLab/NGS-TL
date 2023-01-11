args = commandArgs(trailingOnly=TRUE)

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