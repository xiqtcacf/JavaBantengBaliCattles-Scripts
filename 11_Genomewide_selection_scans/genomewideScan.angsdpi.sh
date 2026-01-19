#!/bin/bash

pop=$1 ##list with targeted populations
export DIR=/home/wlk579/1.0JavaBanteng_project/7.GT.Analyses.FstPi
cd $DIR

source /home/wlk579/Server_seqafrica/apps/modules/activate.sh
module load winsfs

angsd=/home/wlk579/Server_bos/apps/angsd/angsd
realSFS=/home/wlk579/Server_bos/apps/angsd/misc/realSFS
thetaStat=/home/wlk579/Server_bos/apps/angsd/misc/thetaStat
input=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Fastsimcoal27/get_input_all

Banteng_fasta=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta
Banteng_fai=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/bosTau9.fasta.fai
Banteng_sites_filtering=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/CombineAll/CombinedAll.good_sites.Banteng.regions

inputPop=/home/wlk579/1.0JavaBanteng_project/7.GT.Analyses.FstPi/pop

####50K window
while read file ; do

 winsfs $input/WildJavaBanteng.BantengRef.saf.idx  > /home/wlk579/1.0JavaBanteng_project/7.GT.Analyses.FstPi/Bantanc.1dsfs/WildJavaBanteng.Bantanc.1dsfs
 $realSFS saf2theta $input/WildJavaBanteng.BantengRef.saf.idx -outname WildJavaBanteng.BantengRef -sfs Bantanc.1dsfs/WildJavaBanteng.Bantanc.1dsfs
 $thetaStat do_stat WildJavaBanteng.BantengRef.thetas.idx -win 50000 -step 50000  -outnames WildJavaBanteng.BantengRef.thetas.win50k.thetasWindow.gz

 winsfs $input/Bali.BantengRef.saf.idx  > /home/wlk579/1.0JavaBanteng_project/7.GT.Analyses.FstPi/Bantanc.1dsfs/Bali.Bantanc.1dsfs
 $realSFS saf2theta $input/Bali.BantengRef.saf.idx -outname Bali.BantengRef -sfs /home/wlk579/1.0JavaBanteng_project/7.GT.Analyses.FstPi/Bantanc.1dsfs/Bali.Bantanc.1dsfs
 $thetaStat do_stat Bali.BantengRef.thetas.idx -win 50000 -step 50000  -outnames Bali.BantengRef.thetas.win50k.thetasWindow.gz

done < $Banteng_Chr
