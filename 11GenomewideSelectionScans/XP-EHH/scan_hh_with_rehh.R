#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(rehh)

hh<-data2haplohh(hap_file=args[1], polarize_vcf=FALSE, vcf_reader="data.table", chr.name=args[2])
scan<-scan_hh(hh)

# Then write as a file
write.table(scan, file=paste(args[3],"_chr",args[2],".txt",sep=""), sep="\t",quote = F)
