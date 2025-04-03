#!/bin/bash

####revise from Genis's script
batch=$1 ####different reference

NGSadmix=/home/wlk579/Server_bos/apps/NGSadmix/NGSadmix

file=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Admixture_evalAdmix/$batch.all.beagle.gz
nfile=$batch
num=100  # Maximum number of iterations
P=20 #numer of threads/cores used

K=$2
out=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Admixture_evalAdmix/$batch/$K

rm $out/$nfile.$K.likes
mkdir $out

for f in `seq $num`
do
    echo -n -e $f"\t"
    echo $file
    echo $K
    $NGSadmix -likes $file -seed $f -K $K -P $P -printInfo 1 -o $out/$nfile.$K.$f
    grep "like=" $out/$nfile.$K.$f.log | cut -f2 -d " " | cut -f2 -d "=" >> $out/$nfile.$K.likes
    CONV=`Rscript -e "r<-read.table('$out/$nfile.$K.likes');r<-r[order(-r[,1]),];cat(sum(r[1]-r<3),'\n')"` #Check for convergence

    #if [ $CONV -gt 4 ]  #-gt 2 = greater than 2
    if [ $CONV -gt 2 ]  #-gt 2 = greater than 2
    then
        cp $out/$nfile.$K.$f.qopt $out/$nfile.$K.$f.qopt_conv
        cp $out/$nfile.$K.$f.fopt.gz $out/$nfile.$K.$f.fopt_conv.gz
        cp $out/$nfile.$K.$f.log $out/$nfile.$K.$f.log_conv
        break
    fi

done
