#!/bin/bash

batch=$1 ###diff reference e.g. waterbuffaloRef bantengRef
inds_list=$2
export DIR=/home/wlk579/1.0JavaBanteng_project/6.5.Analyses.ROH_length
cd $DIR

source /maps/projects/seqafrica/apps/modules/activate.sh
module load plink
module load python/3.9.5
module load gcc
module load R/4.0.3

bcftools=/home/wlk579/Server_bos/apps/bcftools
File=imputed.maf0.01.r20.95.BantengPro.$batch.sites_variable_noindels_nomultiallelics
input=./$File.bcf.gz

###filtering for bcf files cause here we used low depth data with 1x so no this filtering
#depth filter (10 reads minimum)
#$bcftools plugin setGT --threads 20 $input --include FMT/DP<10 --target-gt q --new-gt . -O b -o Depth10.$File.bcf.gz
#at least two heterozygous reads
#$bcftools plugin setGT --threads 20 Depth10.$File.bcf.gz --include 'FMT/GT=='het' & (FMT/AD[*:0]<3 | FMT/AD[*:1]<3)' --target-gt q --new-gt . -O b -o het2.Depth10.$File.bcf.gz

#########filter and format preparation for one plink file including all individuals 101inds
###get plink input data sets running hardy-weinberg checking, and maf1%, geno0.05 missing
plink --bcf $input \
      --keep-allele-order\
      --allow-extra-chr \
      --chr-set 29 \
      --maf 0.01 \
      --geno 0.05 \
      --het \
      --hardy \
      --ibc \
      --missing \
      --make-bed \
      --set-missing-var-ids "@:#:\$1:\$2" \
      --out hete_checking.maf1.geno5
###filter those SNP sites that have weird observed heterozygote frequency O HET (>0.5)
awk '$7>=0.5' hete_checking.maf1.geno5 |awk '{print $2}' |sed '1d' > hete_checking.maf1.geno5.hwe.OHETabove0.5.list
### remove those sites from plink file
plink --bfile hete_checking.maf1.geno5 \
      --allow-extra-chr \
      --chr-set 29 \
      --exclude hete_checking.maf1.geno5.hwe.OHETabove0.5.list \
      --make-bed \
      --recode \
      --out Filter.maf1.geno5.hwe.OHETabove0.5

##########run ROH per individual level
output=/home/wlk579/1.0JavaBanteng_project/6.5.Analyses.ROH_length/result_ind
while read ind ; do
###get each individual
mkdir $output/$ind
grep $ind Filter.maf1.geno5.hwe.OHETabove0.5.fam > $output/$ind/$ind.keep.fam
###remove all missing from each individual
plink --bfile Filter.maf1.geno5.hwe.OHETabove0.5 \
      --keep-fam $output/$ind/$ind.keep.fam \
      --geno 0 \
      --allow-extra-chr \
      --recode \
      --chr-set 29 \
      --make-bed \
      --out $output/$ind/$ind.Filter.maf1.geno5.hwe.OHETabove0.5
###ROH get
plink --bfile $output/$ind/$ind.Filter.maf1.geno5.hwe.OHETabove0.5 \
      --homozyg \
      --homozyg-window-het 1 \
      --allow-extra-chr \
      --chr-set 29 \
      --out $output/$ind/homozygwindowhet1.$ind.Filter.maf1.geno5.hwe.OHETabove0.5
done < $inds_list
