otu <- read.csv("MLMicrobiome/Data/otu-large.csv")
table(otu$dx)

sample_id <- sprintf("S%03d", seq_len(nrow(otu))) # creates a sample id for each row since the csv does not have an id column
features <- otu[, names(otu) != "dx"] # makes a copy of the table without the label column
# this was done since deepmicro and qiime expect abundances and labels in different files

# deepmicro formatting
labels <- as.integer(otu$dx == "cancer")
write.table(features, "UserDataOTU.csv",  sep = ",", row.names = FALSE, col.names = FALSE)
write.table(labels,   "UserLabelOTU.csv", sep = ",", row.names = FALSE, col.names = FALSE)

#QIIME formatting
meta <- data.frame(`sample-id` = sample_id, dx = otu$dx, check.names = FALSE)
write.table(meta, "qiime2_metadata.tsv", sep = "\t", quote = FALSE, row.names = FALSE)
tab <- t(features)
colnames(tab) <- sample_id
storage.mode(tab) <- "integer"                 

out <- data.frame(`#OTU ID` = rownames(tab), tab, check.names = FALSE)

con <- file("qiime2_feature_table.tsv", "w")
writeLines("# Constructed from biom file", con)
write.table(out, con, sep = "\t", quote = FALSE, row.names = FALSE)
close(con)