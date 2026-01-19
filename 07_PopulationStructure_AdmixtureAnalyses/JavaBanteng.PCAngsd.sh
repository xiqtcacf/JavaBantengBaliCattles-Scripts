#!/bin/bash

batch=$1 ####ref different beagle
export DIR=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.PCA
cd $DIR

pcangsd=/home/wlk579/Server_seqafrica/apps/modules/software/pcangsd/0.99/bin/pcangsd
beagle=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.PCA/$batch.all.beagle.gz

######  estimating individual admixture proportions from NGS data. It is based on genotype likelihoods and works well for low coverage NGS data.

for i in {1..10}
do
$pcangsd -beagle $beagle -e $i -o $batch.Pcangsd.e${i} -minMaf 0.05 -threads 20
done
