args = commandArgs(trailingOnly = TRUE)
# tlCountFile=args[[1]]
# gcStatsFile=args[[2]]
# samtoolsStatsFile=args[[3]]
# kmax=args[[4]]

tlCountFile = "/Users/Kitty/tmp/LTL_tests/NWD883937.ltl.counts.txt.gz"
gcStatsFile = "/Users/Kitty/tmp/LTL_tests/NWD883937.gc.stats.txt.gz"
samtoolsStatsFile = "/Users/Kitty/tmp/LTL_tests/NWD883937.stats.txt.gz"
kmax = 25


tlCounts = read.delim(tlCountFile)
baseStats = read.delim(gcStatsFile, sep = "")
colnames(baseStats) = paste0("mosdepth_gc_coverage_", colnames(baseStats))
stats = readLines(samtoolsStatsFile)
baseStats$READ_LENGTH = as.numeric(strsplit(stats[grep(pattern = "maximum length", stats)], split = "\t")[[1]][[3]])



computeTLInternalCountMD <- function(tl, baseStats, k) {
  telCount = sum(tl[which(tl$RepeatK >= k), ]$Count)
  gcCount = (baseStats$mosdepth_gc_coverage_mean * 1000 * baseStats$mosdepth_gc_coverage_n) / baseStats$READ_LENGTH
  rat = telCount / gcCount
  scale = 332720800 / 1000 / 46
  tl = rat * scale
  resultTmp = data.frame(k = k)
  resultTmp[, paste0("TL_READS_AT_K_", k)] = telCount
  resultTmp[, paste0("LENGTH_ESTIMATE_AT_K_", k)] = tl
  resultTmp$k = NULL
  return(resultTmp)
}

ks = c(1:kmax)

results = baseStats
for (k in ks) {
  estimate = computeTLInternalCountMD(tl = tlCounts,
                                      baseStats = baseStats,
                                      k = k)
  
  results = cbind(results, estimate)
}
print(results)
