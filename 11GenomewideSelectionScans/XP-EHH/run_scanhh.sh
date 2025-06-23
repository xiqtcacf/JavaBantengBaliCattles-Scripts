#!/bin/sh
# This is a series of bash command lines to run XP-EHH

# First filtering the imputed data set to include only samples from Banteng-WildBorn and Bali-Bali
bcftools view -S domesticJavaPop_noAus.SampleID.txt -Oz -o phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.domesticJavaBanteng.vcf.gz phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.vcf.gz
bcftools view -S wildJavaPop_noTexas_zooOnly.SampleID.txt -Oz -o phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.wildJavaBanteng_Zoo.vcf.gz phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.vcf.gz

# removing monomorphic sites on each
bcftools view -e 'COUNT(GT="AA")=N_SAMPLES || COUNT(GT="RR")=N_SAMPLES' -Oz -o phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.wildJavaBanteng_Zoo.allPolymorphic.vcf.gz phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.wildJavaBanteng_Zoo.vcf.gz
bcftools view -e 'COUNT(GT="AA")=N_SAMPLES || COUNT(GT="RR")=N_SAMPLES' -Oz -o phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.domesticJavaBanteng.allPolymorphic.vcf.gz phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.domesticJavaBanteng.vcf.gz

# merge the file after monomorphic sites
bcftools merge --threads 8 phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.wildJavaBanteng_Zoo.allPolymorphic.vcf.gz phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.domesticJavaBanteng.allPolymorphic.vcf.gz -Oz -o phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.wildZoo_dom.allPolymorphic.vcf.gz

# remove missingness from the entire panel of Banteng-WildBorn and Bali-Bali sample set
bcftools view -e 'GT[*] = "mis"' phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.wildZoo_dom.allPolymorphic.vcf.gz -Oz -o phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.wildZoo_dom.allPolymorphic.noMissing.vcf.gz

# divide vcf by Bali-Bali and Banteng-Wildborn to be scanned by rehh.
bcftools view -S domesticJavaPop_noAus.SampleID.txt -Oz -o phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.domesticJavaBanteng.allPolymorphic.noMissing.vcf.gz phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.wildZoo_dom.allPolymorphic.noMissing.vcf.gz &
bcftools view -S wildJavaPop_noTexas_zooOnly.SampleID.txt -Oz -o phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.wildJavaBanteng_Zoo.allPolymorphic.noMissing.vcf.gz phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.wildZoo_dom.allPolymorphic.noMissing.vcf.gz

# Running whole genome scan on each population on parallel in separate chromosomes
for chr in $(seq 1 29); do Rscript scan_hh_with_rehh.R phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.domesticJavaBanteng.allPolymorphic.noMissing.vcf.gz $chr domesticJavaBanteng &; done
for chr in $(seq 1 29); do Rscript scan_hh_with_rehh.R phased.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.wildJavaBanteng_Zoo.allPolymorphic.noMissing.vcf.gz $chr wildJavaBantengZoo &; done
# The above comands will output a wgscan result from rehh using `scan_hh()` command for separate 29 chromosomes
# For each pop, we run a ies2xpehh scan in R
