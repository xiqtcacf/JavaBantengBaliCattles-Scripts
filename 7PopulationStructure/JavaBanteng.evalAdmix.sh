#!/bin/bash

batch=$1 ####different pops
k=$2

####bash JavaBanteng.evalAdmix.10cores.sh JavaOnly.Banteng 2.3

export DIR=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Admixture_evalAdmix/$batch/coverage
cd $DIR

evalAdmix=/home/wlk579/Server_bos/apps/evalAdmix/evalAdmix
beagle=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.Admixture_evalAdmix/$batch.all.beagle.gz


$evalAdmix -beagle $beagle \
           -fname $batch.$k.fopt_conv.gz \
           -qname $batch.$k.qopt_conv \
           -o ../$batch.$k.corres \
           -P 20
