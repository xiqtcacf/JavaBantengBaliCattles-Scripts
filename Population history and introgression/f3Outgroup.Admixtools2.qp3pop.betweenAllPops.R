library(admixtools)
pop2=c('Bali','BaliAustralia','BaliKupang','CaptiveJavaBanteng','WildJavaBanteng','HistoricalJavaBanteng','Gaur','EuropeanTaurine','SouthAsianZebu')
pop3=c('Bali','BaliAustralia','BaliKupang','CaptiveJavaBanteng','WildJavaBanteng','HistoricalJavaBanteng','Gaur','EuropeanTaurine','SouthAsianZebu')
pop1=c('AfricanBuffalo')

extract_f2('/home/wlk579/1.0JavaBanteng_project/7.GT.Analyses.f3outgroup/3His/BantengPro.waterbuffaloRef.sites_variable_noindels_nomultiallelics','/home/wlk579/1.0JavaBanteng_project/7.GT.Analyses.f3outgroup/3His/f3',auto_only = FALSE, blgsize = 5e6 )
f2_blocks = f2_from_precomp('/home/wlk579/1.0JavaBanteng_project/7.GT.Analyses.f3outgroup/3His/f3')
out = f3(f2_blocks, pop1, pop2, pop3)
write.table(out, "f3.extract_f2-f2_blocks.BantengPro.waterbuffaloRef.sites_variable_noindels_nomultiallelics.txt", sep="\t", quote=FALSE, col.names = T, row.names = F)

