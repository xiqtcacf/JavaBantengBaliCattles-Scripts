#!/bin/bash

batch=$1 ####species different reference

ANGSD=/maps/projects/bos/apps/angsd/angsd
BEDTOOLS=/maps/projects/bos/apps/bedtools2/bin/bedtools

outdir=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/CombineAll
outdir_result=/home/wlk579/1.0JavaBanteng_project/3.sites_filtering/CombineAll/$batch

autosome=$outdir/autosomes.$batch.bed
rep=$outdir/NONrepeat.$batch.Good.repeatMasked.bed
map=$outdir/mappability_m1_k150_e2.$batch.bed
dep=$outdir/depth.$batch.all_keep.bed
het=$outdir/excess_het.${batch}_Java.good_e0.bed


$BEDTOOLS intersect -a $autosome -b $rep > $outdir_result/nosexLinkedAndAbnormalScaff_rep.bed
$BEDTOOLS intersect -a $outdir_result/nosexLinkedAndAbnormalScaff_rep.bed -b $het > $outdir_result/nosexLinkedAndAbnormalScaff_rep_het.bed
$BEDTOOLS intersect -a $outdir_result/nosexLinkedAndAbnormalScaff_rep_het.bed -b $dep > $outdir_result/nosexLinkedAndAbnormalScaff_rep_het_dep.bed
$BEDTOOLS intersect -a $outdir_result/nosexLinkedAndAbnormalScaff_rep_het_dep.bed -b $map > $outdir_result/nosexLinkedAndAbnormalScaff_rep_het_dep_map.bed

awk '{print $1"\t"$2+1"\t"$3}' $outdir_result/nosexLinkedAndAbnormalScaff_rep_het_dep_map.bed > $outdir_result/nosexLinkedAndAbnormalScaff_rep_het_dep_map.regions

$ANGSD sites index $outdir_result/nosexLinkedAndAbnormalScaff_rep_het_dep_map.regions

