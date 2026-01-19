#!/bin/bash

module unload gsl/2.7
module unload gcc/10.2.0
module load gcc/10.2.0
module load gsl/2.7
#### bash JavaBantengPro.poolingpops.angsd_ngsLD.sh Bali 5 0.01
pop=$1 ###pop name
n_ind=$2 ###5each samples
rnd_sample=$3
export DIR=/home/wlk579/1.0JavaBanteng_project/6.GL.Analyses.LDdecay_ngsLD/$pop
cd $DIR

Banteng_fasta=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta
Banteng_fai=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta.fai
Banteng_sites_filtering=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/CombineAll/Banteng/nosexLinkedAndAbnormalScaff_rep_het_dep_map.regions
Banteng_Chr=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/Banteng_PlusMt.draft.fasta.fai.autosomes.list

angsd=/home/wlk579/Server_bos/apps/angsd/angsd
realSFS=/home/wlk579/Server_bos/apps/angsd/misc/realSFS
thetaStat=/home/wlk579/Server_bos/apps/angsd/misc/thetaStat
ngsLD=/home/wlk579/Server_bos/apps/ngsLD/ngsLD

while read Chr ; do
$angsd -bam ../$pop.list.bam -ref $Banteng_fasta -out $pop.BantengRef.$Chr -r $Chr -sites $Banteng_sites_filtering  \
        	-minMapQ 30 -minQ 20 -doCounts 1 \
        	-GL 2 -doMajorMinor 1 -doMaf 1 -skipTriallelic 1 \
        	-doGlf 4 -SNP_pval 1e-6 -nThreads 30

zless $pop.BantengRef.$Chr.mafs.gz | cut -f1,2 > $pop.BantengRef.$Chr.mafs.pos ####get pos file
NSITES=`zcat $pop.BantengRef.$Chr.mafs.gz | tail -n+2 | wc -l` ### how to calculate the number of sites
$ngsLD --geno $pop.BantengRef.$Chr.glf.gz --min_maf 0.05 \
       --posH $pop.BantengRef.$Chr.mafs.pos --extend_out --log_scale T --n_threads 30 --n_ind $n_ind --n_sites $NSITES --rnd_sample $rnd_sample \
       --outH maf0.05.$pop.BantengRef.$Chr.$rnd_sample.$n_ind.ld
done < $Banteng_Chr
