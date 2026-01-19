# We first make a SIFT database from banteng genome annotation

# Making SIFT Databases
for chr in $(seq 1 29); do mkdir SIFT_database_chr$chr; done
for chr in $(seq 1 29); do mkdir -p SIFT_database_chr$chr/chr-src; done
for in $(seq 1 29); do mkdir -p SIFT_database_chr$chr/gene-annotation-src; done
for chr in $(seq 1 29); do ln -s /maps/projects/bos/people/mdn487/FstScan_wildJavaBanteng_domesticBaliCattle/bam_bantengRef/GCF_032452875.1_ARS-OSU_banteng_1.0_protein.fa/ncbi_dataset/data/GCF_032452875.1/ARS-OSU_banteng_1.0.GCF_032452875.1.pep.fa.gz SIFT_database_chr$chr/gene-annotation-src/; done
zcat GCF_032452875.1_ARS-OSU_banteng_1.0.gtf/ncbi_dataset/data/GCF_032452875.1/ARS-OSU_banteng_1.0.GCF_032452875.1.gtf.gz | grep -v "^#" | cut -f 1 | uniq | head -n 29 > banteng_chrNames_autosome.txt
for chr in $(seq 1 29); do zcat GCF_032452875.1_ARS-OSU_banteng_1.0.gtf/ncbi_dataset/data/GCF_032452875.1/ARS-OSU_banteng_1.0.GCF_032452875.1.gtf.gz | grep ^$(sed -n ${chr%}p banteng_chrNames_autosome.txt) >> SIFT_database_chr$chr/gene-annotation-src/ARS-OSU_banteng_1.0.GCF_032452875.1.chr$chr.gtf; done
for chr in $(seq 1 29); do gzip SIFT_database_chr$chr/gene-annotation-src/ARS-OSU_banteng_1.0.GCF_032452875.1.chr$chr.gtf; done

# split genomic fasta by chromosome
~/bin/faSplit byname <(zcat GCF_032452875.1_ARS-OSU_banteng_1.0_genomic.fna.gz) GCF_032452875.1_ARS-OSU_banteng_1.0.chromosomes/
parallel --keep --link cp {1} SIFT_database_chr{2}/chr-src/ARS-OSU_banteng_1.0.GCF_032452875.1.chromosome.{2}.fa ::: $(ls GCF_032452875.1_ARS-OSU_banteng_1.0.chromosomes/NC_0838* | sed -n 2,29p) ::: $(seq 2 29)
for chr in $(seq 2 29); do gzip SIFT_database_chr${chr%}/chr-src/ARS-OSU_banteng_1.0.GCF_032452875.1.chromosome.${chr%}.fa; done

# Separating chromosomes for per-chromosome VCF annotation of SIFT
parallel -j 29 bcftools view -r {} -Oz -o ../bcf_plink_bantengRef/imputed.maf0.01.r20.95.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.{}.vcf.gz ../bcf_plink_bantengRef/imputed.maf0.01.r20.95.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.vcf.gz ::: $(seq 1 29)
# Changing chromosome names in SIFT database
for chr in $(seq 1 29); do mv SIFT_database_chr${chr%}/GCF_032452875.1/*.gz SIFT_database_chr1/GCF_032452875.1/${chr%}.gz; done
for chr in $(seq 1 29); do mv SIFT_database_chr${chr%}/GCF_032452875.1/*.regions SIFT_database_chr${chr%}/GCF_032452875.1/${chr%}.regions; done 
for chr in $(seq 1 29); do mv SIFT_database_chr${chr%}/GCF_032452875.1/*_SIFTDB_stats.txt SIFT_database_chr${chr%}/GCF_032452875.1/${chr%}_SIFTDB_stats.txt; done
# annotating vcf with single transcript mode
for chr in $(seq 1 29); do java -jar ../../pur_sel/SIFT4G_Annotator.jar -c -i ../bcf_plink_bantengRef/imputed.maf0.01.r20.95.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.${chr%}.vcf -d SIFT_database_chr${chr%}/GCF_032452875.1 -r .; done
ls imputed.maf0.01.r20.95.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.*vcf | sort -V > sift_vcf.txt
bcftools concat --threads 8 -f sift_vcf.txt -Oz -o imputed.maf0.01.r20.95.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.allChr_SIFT_predictions.vcf.gz

# Getting deleterious sites
bcftools concat --threads 8 -f sift_vcf.txt -Oz -o imputed.maf0.01.r20.95.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.allChr_SIFT_predictions.vcf.gz
bcftools view -H imputed.maf0.01.r20.95.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.allChr_SIFT_predictions.vcf.gz | grep "SIFTINFO" | cut -f 1-8 | sed 's/|/\t/g' > imputed.maf0.01.r20.95.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.SIFTpredictions.txt
awk '!($13=="SYNONYMOUS" && $20=="DELETERIOUS")' imputed.maf0.01.r20.95.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.SIFTpredictions.txt > imputed.maf0.01.r20.95.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.SIFTpredictions.clean.txt

# Making bed file to run summation of SIFT score per sample
awk '$20=="DELETERIOUS"' imputed.maf0.01.r20.95.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.SIFTpredictions.clean.txt | awk -v OFS="\t" '{print $1,$2-1,$2}' > imputed.maf0.01.r20.95.BantengPro.bantengRef.sites_variable_noindels_nomultiallelics.SIFTdeleterious.bed
