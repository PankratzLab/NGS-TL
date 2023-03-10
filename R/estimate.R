# Compute TL using mosdepth based GC estimate and TL read counts
# Trying to stick with base R and no other dependencies, for the time being.
args = commandArgs(trailingOnly = TRUE)
tlCountFile = args[[1]]
gcStatsFile = args[[2]]
samtoolsStatsFile = args[[3]]
output = args[[4]]

tlCounts = read.delim(tlCountFile)
baseStats = read.delim(gcStatsFile, sep = "")
colnames(baseStats) = paste0("mosdepth_gc_coverage_", colnames(baseStats))
stats = readLines(samtoolsStatsFile)
baseStats$READ_LENGTH = as.numeric(strsplit(stats[grep(pattern = "maximum length", stats)], split = "\t")[[1]][[3]])


# compute TL in a somewhat similar fashion as TelSeq (https://github.com/zd1/telseq/blob/48c2ebcf2694a8396d96b3502a5188b9075ddba6/src/Telseq/telseq.cpp#L468-L489), but using proxies for gc content normalization (from mosdepth), and only counting telomeric reads ~25kb +/- of chromsome ends.
computeTLInternalCountMD <- function(tl, baseStats, k) {
  telCount = sum(tl[which(tl$RepeatK >= k),]$Count)
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

results = baseStats
kmax = max(tlCounts$RepeatK)
for (k in c(1:kmax)) {
  estimate = computeTLInternalCountMD(tl = tlCounts,
                                      baseStats = baseStats,
                                      k = k)
  
  results = cbind(results, estimate)
}
print(results)
gzout = gzfile(output)
write.table(
  results,
  file = gzout,
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = TRUE
)
