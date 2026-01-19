#!/bin/bash

#batch=$1 ##list with targeted populations
export DIR=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Fastsimcoal27/1.2popModel_bootstrap_NonParametric/input
cd $DIR

input_path=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Fastsimcoal27/1.2popModel_bootstrap_NonParametric/input
module load R/4.0.3

angsd=/home/wlk579/Server_bos/apps/angsd/angsd
#realSFS=/home/wlk579/Server_bos/apps/angsd/misc/realSFS
inputPop=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Fastsimcoal27/0getcorrect_sfs/pop_info

Banteng_fasta=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta
Banteng_fai=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta.fai
Banteng_sites_filtering=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/CombineAll/CombinedAll.good_sites.Banteng.regions

###get 100 jacknife input files: unfold format
#winsfs split --threads 40 -S 100 --tolerance 1e-8 --sfs ./WildJava.Bali.sfs ./WildJava.BantengRef.saf.idx ./Bali.BantengRef.saf.idx > ./winsfs.WildJava.Bali.sfs.100bootstraps
### split them into 100 files: susbstract each block values
#split -l2 --numeric-suffixes=0 winsfs.WildJava.Bali.sfs.100bootstraps 1
### fold 2dsfs and change into fsc format
for i in {100..199}
do
  winsfs view --fold $i > folded.$i.2dsfs
  Rscript ../From2dsfswinsfsToMatrix.R $input_path folded.$i.2dsfs
  cat $input_path/header.row $input_path/bootstrap.2dsfs.matrix > $input_path/y
  paste $input_path/header.column $input_path/y > $input_path/Using.folded.$i.2dsfs
  rm $input_path/bootstrap.2dsfs.matrix $input_path/y folded.$i.2dsfs
done
