#!/bin/bash

export DIR=/home/wlk579/1.0JavaBanteng_project/0.Reference_Banteng_BosTau9_Waterbuffol_comparison/
cd $DIR

batch=$1

###### evaluate quality of assembly, using quast5.0.2 old analyses
#./quast.py /isdata/hellergrp/wlk579/reference_Bos/Bubalus_bubalis_WaterBuffalo_GCF_003121395.1_refseq_2018/GCF_003121395.1_ASM312139v1_genomic.fna.gz -o /isdata/hellergrp/wlk579/reference_comparison/waterBuffalo -L --gene-finding --eukaryote --split-scaffolds

###### evaluate quality of assembly, using BUSCO-4.5.5

run_BUSCO=/home/wlk579/Server_bos/apps/mamba/install/envs/busco5/lib/python3.9/site-packages/busco/run_BUSCO.py
#conda activate busco5

python3 $run_BUSCO -m genome -i $batch.fasta -o $batch.eukaryota -l eukaryota_odb10 -c 20
python3 $run_BUSCO -m genome -i $batch.fasta -o $batch.cetartiodactyla -l cetartiodactyla_odb10 -c 20

### draw figures
plot=/home/wlk579/Server_bos/apps/mamba/install/envs/busco5/bin/generate_plot.py

python3 $plot -wd $batch.eukaryota
python3 $plot -wd $batch.cetartiodactyla
