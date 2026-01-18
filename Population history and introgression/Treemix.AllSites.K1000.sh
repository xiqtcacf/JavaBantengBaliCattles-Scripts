#!/bin/bash

batch=$1 ###diff reference e.g. waterbuffaloRef used here for remove bias when using Banteng reference
batch2=$2
export DIR=/home/wlk579/1.0JavaBanteng_project/7.GT.Analyses.Treemix/FinalUsing_allSites_k1000/5Each_3Each/
cd $DIR

source /maps/projects/seqafrica/apps/modules/activate.sh
module load plink
module load gcc
module load R/4.0.3
module load perl
module load vcftools
bcftools=/home/wlk579/Server_bos/apps/bcftools
glactools=/home/wlk579/Server_bos/apps/glactools/glactools
tabix=/home/wlk579/Server_bos/apps/htslib/tabix
bgzip=/home/wlk579/Server_bos/apps/htslib/bgzip

File=imputed.maf0.01.r20.95.BantengPro.$batch.sites_variable_noindels_nomultiallelics
input=./$File.bcf.gz
keep_inds=$batch2 ###pure samples will be kept

###Step1 transfer bcf to vcf and index
$bcftools view $input -Ov -o $File.vcf
$bgzip $File.vcf && $tabix -p vcf $File.vcf.gz
### step2 remove missing data and perform LD-pruning(scripts downloaded)
vcftools --gzvcf $File.vcf.gz --max-missing 1 --recode --stdout | gzip > $File.noN.vcf.gz
bash scripts/ldPruning.sh $File.noN.vcf.gz ###
gzip $File.noN.LDpruned.vcf ###Not using

### step additional get data sets with 5/3 pure samples(no admix, noKing) for each populations,3His or 1His
vcftools --gzvcf $File.noN.vcf.gz --keep $keep_inds --recode --stdout | gzip > $keep_inds.$File.noN.vcf.gz

### step3 get treemix input file
vcftools --gzvcf $keep_inds.$File.noN.vcf.gz \
         --plink \
         --mac 2 \
         --remove-indels \
         --max-alleles 2 \
         --chrom-map filename.chrom-map.txt \
         --out $keep_inds.$File.noN

plink --file $keep_inds.$File.noN \
      --make-bed \
      --allow-no-sex \
      --allow-extra-chr \
      --out $keep_inds.$File.noN

plink --bfile $keep_inds.$File.noN \
      --freq \
      --missing \
      --within $keep_inds.popInfo.clust \
      --allow-no-sex \
      --allow-extra-chr \
      --out $keep_inds.$File.noN

gzip $keep_inds.$File.noN.frq.strat
python scripts/plink2treemix.py $keep_inds.$File.noN.frq.strat.gz $keep_inds.treemix.frq.gz

###run treemix
input_file=$keep_inds.treemix.frq.gz
out_dir=/maps/projects/bos/people/wlk579/Banteng_project/7.GT.Analyses.Treemix/allSites_k1000/5Each_3Each/results.5each.3His3Gaur3Africa.bootstraps


###run treemix for normal runs
for m in `seq 0 1`; do
    mkdir ${out_dir}/m${m}
    rm $out_dir/m${m}_all.likes
       for seed in `seq 1 100`; do
           treemix -i $input_file -o $out_dir/m${m}/banteng_treemix_m${m}_${seed} -m $m -root AfricanBuffalo -k 1000 -seed $seed | tee out_dir/m${m}/banteng_treemix_m${m}_${seed}.log
           tail -1 $out_dir/m${m}/banteng_treemix_m${m}_${seed}.llik | cut -f2 -d":" >> $out_dir/m${m}_all.likes
       done
done


### do bootstraps using treemix programme
for m in 0 1; do
    mkdir -p $out_dir/m${m}
    rm -f $out_dir/m${m}/all_treemix_boot_m${m}.trees
    rm -f $out_dir/m${m}_all.likes
 for i in `seq 1 100`; do
        treemix -i $input_file -o $out_dir/m${m}/banteng_treemix_m${m}_boot_${i} -m ${m} -root AfricanBuffalo -k 1000 -bootstrap -seed ${i} | tee $out_dir/m${m}/banteng_treemix_m${m}_boot_${i}.log
        zcat $out_dir/m${m}/banteng_treemix_m${m}_boot_${i}.treeout.gz | head -1 >> $out_dir/m${m}/all_treemix_boot_m${m}.trees
        tail -1 $out_dir/m${m}/banteng_treemix_m${m}_boot_${i}.llik | cut -f2 -d":" >> $out_dir/m${m}_all.likes
 done
done


###bootstraps 80% input snps
for m in {0..1}; do
    mkdir ${out_dir}/m${m}
    rm $out_dir/m${m}_all.likes
    for seed in {1..100}; do
        # Generate bootstrapped input file with ~80% of the SNP loci
        gunzip -c $input_file | awk 'BEGIN {srand()} { if (NR==1) {print $0} else if (rand() <= .8) print $0}' | gzip > $out_dir/m${m}/$seed.$m.$keep_inds.treemix.frq.gz
        # Run treemix on bootstrapped input file
        treemix -i $out_dir/m${m}/$seed.$m.$keep_inds.treemix.frq.gz -o $out_dir/m${m}/banteng_treemix_m${m}_${seed} -m $m -root AfricanBuffalo -k 1000 -seed $seed | tee $out_dir/m${m}/banteng_treemix_m${m}_${seed}.log
        tail -1 $out_dir/m${m}/banteng_treemix_m${m}_${seed}.llik | cut -f2 -d":" >> $out_dir/m${m}_all.likes
    done
done

