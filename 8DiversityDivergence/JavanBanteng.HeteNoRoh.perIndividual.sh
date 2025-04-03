#!/bin/bash

batch=$1 #### each 20 individual as one batch, xaa, xab, xac...

export DIR=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.diversity_ROH/diversity_NoROHs/$batch
cd $DIR

bedtools=/home/wlk579/Server_bos/apps/bedtools2/bin/bedtools
bcftools=/home/wlk579/Server_bos/apps/bcftools
#realSFS=/home/users/xi/software/angsd/misc/realSFS instead using,,,,,winSFS

angsd=/maps/projects/bos/apps/angsd/angsd
fasta=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta
fai=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta.fai
sites_filtering=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/CombineAll/Banteng/nosexLinkedAndAbnormalScaff_rep_het_dep_map.bed
input=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/0Using.allBams.passedQC

###get sites by removing ROH >0.5M from good_bed.sites per individual

while read ind ; do

 grep "$ind" ../homozygwindowhet1.all.hom > $ind.ROH.location
 Rscript get_correct.ROH.regions.R $ind.ROH.location
 rm $ind.ROH.location
 sed '1d' -i bed.txt
 mv bed.txt $ind.bed.txt
 $bedtools subtract -a $sites_filtering -b $ind.bed.txt > $ind.Good_sites_Banteng_NoRoh.bed
 rm $ind.bed.txt
 awk '{print $1"\t"$2+1"\t"$3}' $ind.Good_sites_Banteng_NoRoh.bed > $ind.Good_sites_Banteng_NoRoh.regions
 rm $ind.Good_sites_Banteng_NoRoh.bed

 $angsd sites index $ind.Good_sites_Banteng_NoRoh.regions
 $angsd -i $input/$ind.Banteng.bam -out $ind -doSaf 1 -anc $fasta -sites $ind.Good_sites_Banteng_NoRoh.regions -minMapQ 25 -minQ 30 -GL 2 -P 10
 winsfs $ind.saf.idx -t 10 > $ind.saf.idx.sfs

done < ../../$batch
