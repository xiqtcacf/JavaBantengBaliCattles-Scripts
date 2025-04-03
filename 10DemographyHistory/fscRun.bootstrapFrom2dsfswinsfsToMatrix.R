######first step to transfer angsd 2dsfs to fastsimcoal input files in R, sfs <- matrix(sfs, ncol=(n1*2+1), nrow=(n2*2+1)), where n1 is the first population in the name and n2 the second 
args <- commandArgs(T)
setwd(args[1])
#### get divergence input file for dfe-alpha
data <- read.table(args[2],header = F)
data1 <- matrix(data,ncol = 11,nrow = 55)
write.table(data1, "bootstrap.2dsfs.matrix", sep="\t", col.names = F, row.names = FALSE, quote=FALSE)
