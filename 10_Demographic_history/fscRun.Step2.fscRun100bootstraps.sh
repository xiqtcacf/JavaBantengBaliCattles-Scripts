#!/bin/bash

batch=$1  ####model name
bootstrap=$2 ###which bootstrap input name

input=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Fastsimcoal27/1.2popModel_bootstrap_NonParametric
fsc27=/home/wlk579/Server_bos/apps/fsc27_linux64/fsc27093


mkdir $input/Result/$bootstrap

for i in {1..20}
do
 mkdir $input/Result/$bootstrap/$i

 cp $input/$batch.est $input/Result/$bootstrap/$i/$i.est
 cp $input/$batch.tpl $input/Result/$bootstrap/$i/$i.tpl
 cp $input/input/Using.folded.$bootstrap.2dsfs $input/Result/$bootstrap/$i/${i}_jointMAFpop1_0.obs
 #cp $input/_jointMAFpop2_0.obs $input/$batch/$i/${i}_jointMAFpop2_0.obs
 #cp $input/_jointMAFpop2_1.obs $input/$batch/$i/${i}_jointMAFpop2_1.obs

 export DIR=$input/Result/$bootstrap/$i
 cd $DIR

 $fsc27 -t $i.tpl -n500000 -e $i.est -M -L100 -m -c10 -r ${i}

 #rm $i.est
 #rm $i.tpl
 #rm ${i}_jointMAFpop1_0.obs
 #rm ${i}_jointMAFpop2_0.obs
 #rm ${i}_jointMAFpop2_1.obs

done
