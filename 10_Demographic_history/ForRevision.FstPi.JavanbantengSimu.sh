#!/bin/bash

#batch=$1 ####

export DIR=/home/wlk579/1.0JavaBanteng_project/0.CB_Revisions/SelectionNeutralModel/50000Simu_1_50000bp_segments/
cd $DIR

#conda activate Python3.9.4
module purge
module load plink ###plink2
module load perl
module load vcftools  ###vcftools/0.1.16
module load python/3.9.9 ###calculate Pi
module load gcc
module load R/4.0.3

fsc=/home/wlk579/Server_bos/apps/fsc27_linux64/fsc27093

###simulate 49320 simulations with each 50000bp usig afstsimcoal2 under neutral model,
$fsc -i 68_simulate.par -n49320 -j -m -s0 -I -q -G -x

### calcultae Fst per simulation
## transfer each simulationed genotype table into vcf,calculate Fst per simulated dats sets
gen2vcf=/home/wlk579/1.0JavaBanteng_project/0.CB_Revisions/SelectionNeutralModel/gen2vcf.py
for i in {1..49320}
do
 python3 $gen2vcf --input 68_simulate/68_simulate_1_${i}.gen --output 68_simulate_vcf/68_simulate_1_${i}.gen.vcf --chr_info 1 50000
 plink2 --vcf 68_simulate_vcf/68_simulate_1_${i}.gen.vcf \
        --allow-extra-chr \
        --make-bed \
        --out 68_simulate_plink/68_simulate_1_${i}.gen

 cp ../Using.68_simulate.gen.fam 68_simulate_plink/68_simulate_1_${i}.gen.fam
# Hunson Fst, plink2
  plink2 --bfile 68_simulate_plink/68_simulate_1_${i}.gen \
         --fst ../Using.68_simulate.gen.fam.poplist.new.txt \
         --family ../Using.68_simulate.gen.fam.poplist.new.txt \
         --allow-extra-chr \
         --out result/68_simulate_1_${i}.gen.Plink2.Fst

## Calcualte Fst based on fatsimcoal2 auto output 2dSFS, for sanity checking
  cp ../68_simulate/68_simulate_${i}/68_simulate_jointMAFpop1_0.obs ./
  sed -i '1d' ./68_simulate_jointMAFpop1_0.obs
  sed -i '1d' ./68_simulate_jointMAFpop1_0.obs
  cut -f2-12 ./68_simulate_jointMAFpop1_0.obs > ./68_simulate_jointMAFpop1_0.txt
  rm ./68_simulate_jointMAFpop1_0.obs
  Rscript Xi_modified_fstFrom2dRHELLER.R > a
  mv a 68_simulate_${i}.fstFrom2dsfs
  rm ./68_simulate_jointMAFpop1_0.txt


### pairwise diversity
asfsp=/home/wlk579/0.Hartebeest/All_new_Hartebeest/1.Analyses/Fst_Dxy_pop/dxy_pop_xiaodongScript/asfsp/asfsp.py

## Calcualte pi based on fastsimcoal2 auto output 1dSFS

 cp 68_simulate/68_simulate_${i}/68_simulate_MAFpop0.obs result_pi/68_simulate_${i}.68_simulate_MAFpop0.obs
 sed -i '1d' result_pi/68_simulate_${i}.68_simulate_MAFpop0.obs
 sed -i '1d' result_pi/68_simulate_${i}.68_simulate_MAFpop0.obs
 python3 $asfsp --input result_pi/68_simulate_${i}.68_simulate_MAFpop0.obs --dim 10 --calc pi > result_pi/68_simulate_${i}.WildJava.pi
 rm result_pi/68_simulate_${i}.68_simulate_MAFpop0.obs

 cp 68_simulate/68_simulate_${i}/68_simulate_MAFpop1.obs result_pi/68_simulate_${i}.68_simulate_MAFpop1.obs
 sed -i '1d' result_pi/68_simulate_${i}.68_simulate_MAFpop1.obs
 sed -i '1d' result_pi/68_simulate_${i}.68_simulate_MAFpop1.obs
 python3 $asfsp --input result_pi/68_simulate_${i}.68_simulate_MAFpop1.obs --dim 54 --calc pi > result_pi/68_simulate_${i}.Bali.pi
 rm result_pi/68_simulate_${i}.68_simulate_MAFpop1.obs

done

