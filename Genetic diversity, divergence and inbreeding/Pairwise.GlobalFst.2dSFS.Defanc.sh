#!/bin/bash

batch=$1
export DIR=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Fst/
cd $DIR

source /home/wlk579/Server_seqafrica/apps/modules/activate.sh
module load winsfs

file1=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Fst/$batch.1
file2=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Fst/$batch.2

angsd=/home/wlk579/Server_bos/apps/angsd/angsd
realSFS=/home/wlk579/Server_bos/apps/angsd/misc/realSFS
input=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Fst/input

Banteng_fasta=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta
Banteng_fai=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta.fai
Banteng_sites_filtering=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/CombineAll/Banteng/nosexLinkedAndAbnormalScaff_rep_het_dep_map.regions

#step1.Banteng ref for subspecies
$angsd -bam pop/$batch.BantengRef.bamlist -out $batch.BantengRef -doSaf 1 -anc $Banteng_fasta -sites $Banteng_sites_filtering -minMapQ 25 -minQ 30 -GL 2 -nThreads 10

#step2.Do 2dsfs from Banteng ref saf files, use it to estimate global fsts
while IFS= read -r line1 && IFS= read -r line2 <&3; do
   winsfs shuffle --output $line1.$line2.Bantanc.saf.shuf $input/$line1.BantengRef.saf.idx $input/$line2.BantengRef.saf.idx
   winsfs $line1.$line2.Bantanc.saf.shuf > $line1.$line2.Bantanc.2dsfs
   winsfs $input/$line1.BantengRef.saf.idx $input/$line2.BantengRef.saf.idx > $line1.$line2.Bantanc.2dsfs
   sed -i '1d' $line1.$line2.Bantanc.2dsfs
   $realSFS fst index -whichFst 1 $input/$line1.BantengRef.saf.idx $input/$line2.BantengRef.saf.idx -P 10 -sfs $line1.$line2.Bantanc.2dsfs -fstout $line1.$line2.Bantanc
   $realSFS fst stats $line1.$line2.Bantanc.fst.idx > $line1.$line2.Bantanc.Fst
done < $file1 3< $file2
