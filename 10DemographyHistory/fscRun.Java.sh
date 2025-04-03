#!/bin/bash

#num_procs=5
#num_jobs="\j"
#for i in {1..100}; do

#   while (( ${num_jobs@P} >= num_procs )); do
#      #echo "${num_jobs@P} "
#    wait -n
#   done

batch=$1  ####model name
input=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Fastsimcoal27/1.2popModel
fsc27=/home/wlk579/Server_bos/apps/fsc27_linux64/fsc27093

for i in {1..100}
do

mkdir $input/$batch/$i
cp $input/$batch.est $input/$batch/$i/$i.est
cp $input/$batch.tpl $input/$batch/$i/$i.tpl
cp $input/_jointMAFpop1_0.obs $input/$batch/$i/${i}_jointMAFpop1_0.obs
#cp $input/_jointMAFpop2_0.obs $input/$batch/$i/${i}_jointMAFpop2_0.obs
#cp $input/_jointMAFpop2_1.obs $input/$batch/$i/${i}_jointMAFpop2_1.obs

export DIR=$input/$batch/$i
cd $DIR

$fsc27 -t $i.tpl -n500000 -e $i.est -M -L100 -m -c10 -r ${i}

#rm $i.est
#rm $i.tpl
#rm ${i}_jointMAFpop1_0.obs
#rm ${i}_jointMAFpop2_0.obs
#rm ${i}_jointMAFpop2_1.obs

done
