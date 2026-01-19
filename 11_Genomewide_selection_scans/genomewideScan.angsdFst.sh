#!/bin/bash

batch=$1 ##list with targeted populations
export DIR=/maps/projects/bos/people/wlk579/Banteng_project/7.GT.Analyses.genomewideScan.FstPi/Fst
cd $DIR

source /home/wlk579/Server_seqafrica/apps/modules/activate.sh
module load winsfs

angsd=/home/wlk579/Server_bos/apps/angsd/angsd
realSFS=/home/wlk579/Server_bos/apps/angsd/misc/realSFS
inputPop=/home/wlk579/1.0JavaBanteng_project/7.GT.Analyses.FstPi/pop

Banteng_fasta=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta
Banteng_fai=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta.fai
Banteng_sites_filtering=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/CombineAll/CombinedAll.good_sites.Banteng.regions

# Do saf per chromosome, per subspecies
while read file ; do
$angsd -bam $inputPop/$batch.bam -out $batch.BantengRef.$file -doSaf 1 -anc $Banteng_fasta -r $file -sites $Banteng_sites_filtering -minMapQ 25 -minQ 30 -GL 2 -nThreads 20
done < ../Banteng_PlusMt.draft.fasta.fai.autosomes.list

# calculate 2dsfs and the Fst by sliding window
while read chr; do

winsfs WildJavaBanteng.BantengRef.$chr.saf.idx Bali.BantengRef.$chr.saf.idx > WildJavaBanteng.Bali.BantengRef.$chr.2dsfs
$realSFS fst index -whichFst 1 WildJavaBanteng.BantengRef.$chr.saf.idx Bali.BantengRef.$chr.saf.idx -P 30 -sfs WildJavaBanteng.Bali.BantengRef.$chr.2dsfs -fstout WildJavaBanteng.Bali.BantengRef.$chr
$realSFS fst stats2 WildJavaBanteng.Bali.BantengRef.$chr.fst.idx -win 50000 -step 50000 > WildJavaBanteng.Bali.BantengRef.$chr.fst.win50K

# for revision to check the influence of step size to results
StepOutput=/maps/projects/bos/people/wlk579/Banteng_project/0.CB_Revisions/Fst_stepWindow/
$realSFS fst stats2 WildJavaBanteng.Bali.BantengRef.$chr.fst.idx -win 50000 -step 10000 > $StepOutput/WildJavaBanteng.Bali.BantengRef.$chr.fst.win50Kstep10K

done < ../1Banteng_PlusMt.draft.fasta.fai.autosomes.list

