#!/bin/bash

batch=$1 ####individual name per batch
export DIR=/home/wlk579/1.0JavaBanteng_project/6.3.Analyses.diversity_ROH/diversity
cd $DIR

angsd=/maps/projects/bos/apps/angsd/angsd
#realSFS=/home/users/xi/software/angsd/misc/realSFS instead using,,,,,winSFS

fasta=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta
fai=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta.fai
sites_filtering=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/CombineAll/Banteng/nosexLinkedAndAbnormalScaff_rep_het_dep_map.regions
input=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/0Using.allBams.passedQC


while read file ; do

$angsd -i $input/$file.Banteng.bam -out $file -doSaf 1 -anc $fasta -sites $sites_filtering -minMapQ 25 -minQ 30 -GL 2 -P 10
winsfs $file.saf.idx -t 10 > $file.saf.idx.sfs

#$angsd -i $input/$file.Banteng.bam -out results_noTrans/$file -doSaf 1 -anc $fasta -sites $sites_filtering -minMapQ 25 -minQ 30 -GL 2 -noTrans 1 -P 10
#winsfs results_noTrans/$file.saf.idx -t 10 > results_noTrans/$file.saf.idx.sfs

done < $batch
