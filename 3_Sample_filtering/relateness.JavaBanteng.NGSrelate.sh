#!/bin/bash

batch=$1
Hinds=$2
inds=$3
export DIR=/home/wlk579/1.0JavaBanteng_project/2.QC_Samples/NGSrelate/
cd $DIR

angsd=/home/wlk579/Server_bos/apps/angsd/angsd
ngsRelate=/home/wlk579/Server_bos/apps/NGSrelate/ngsRelate/ngsRelate
bams=/home/wlk579/1.0JavaBanteng_project/2.QC_Samples/NGSrelate/pop_info/$batch.txt
sites_filtering=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/CombineAll/CombinedAll.good_sites.Banteng.regions
sampleID=/home/wlk579/1.0JavaBanteng_project/2.QC_Samples/NGSrelate/pop_info/$batch.samplesID.list

### First we generate a file with allele frequencies (angsdput.mafs.gz) and a file with genotype likelihoods (angsdput.glf.gz).
$angsd -bam $bams -out JavaPro.$batch -GL 2 -doGlf 3 -minInd $Hinds -dosnpstat 1 -doHWE 1 -hwe_pval 1e-6 -doMajorMinor 1 -doMaf 1 -minmaf 0.05 -minMapQ 30 -minQ 20 -SNP_pval 1e-6 -sites $sites_filtering -nThreads 10
### Then we extract the frequency column from the allele frequency file and remove the header (to make it in the format NgsRelate needs)
zcat JavaPro.$batch.mafs.gz | cut -f5 | sed 1d > freq
### run NgsRelate
$ngsRelate -g JavaPro.$batch.glf.gz -f freq -n $inds -O JavaPro.$batch.res -z $sampleID -p 10
