#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
options("scipen"=100, "digits"=4)
library(rehh)

f1<-list.files(path = args[1], pattern = args[2], full.names = T)
f2<-list.files(path = args[1], pattern = args[3], full.names = T)
paste("Reading",f1)
l1<-lapply(f1, read.table)
paste("Reading",f2)
l2<-lapply(f2, read.table)
d1<-do.call(rbind, l1)
d2<-do.call(rbind, l2)
rm(l1)
rm(l2)

paste("This is the first five lines of pop1")
head(d1)
paste("This is the first five lines of pop2")
head(d2)

print("Now calculating XP-EHH")
x<-ies2xpehh(scan_pop1=d1,
             scan_pop2=d2,
             popname1=args[4],
             popname2=args[5])
print("Done calculating, now writing up results")
# Then write as a file
write.table(x, file=paste(args[4],"-to-",args[5],"_xpehh.txt",sep=""), sep="\t",quote = F, row.names=F)
