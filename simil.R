#!/usr/bin/env Rscript
library("textreuse")
library("dplyr")

wideScreen <- function(howWide=Sys.getenv("COLUMNS")) {
  options(width=as.integer(howWide))
}

wideScreen(211)

#dir <- "/home/azambuja/corpus/baba-cosmica"
dir <- "/home/azambuja/corpus/beatles"

options("mc.cores" = 24L)

ats_minhash <- minhash_generator(n = 200, seed = 923)
ats <- TextReuseCorpus(dir = dir, tokenizer = tokenize_ngrams, n = 5, minhash_func = ats_minhash)
lsh_threshold(h = 200, b = 100) %>% round(2)

buckets <- lsh(ats, bands = 100)

ats_matches <- buckets %>%
    lsh_candidates() %>%
    lsh_compare(ats, jaccard_similarity)


#ats_matches %>% arrange(desc(score))
write.csv(ats_matches %>% arrange(desc(score)), file = "output.txt")
