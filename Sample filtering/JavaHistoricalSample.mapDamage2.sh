conda activate base
module load gsl
module load R/4.0.3
./mapDamage -i input/B._javanicus_Java_643.Banteng.bam -r Banteng_PlusMt.draft.fasta --merge-reference-sequences
./mapDamage -i input/B._javanicus_Java_904.Banteng.bam -r Banteng_PlusMt.draft.fasta --merge-reference-sequences
./mapDamage -i input/B._javanicus_Java_906.Banteng.bam -r Banteng_PlusMt.draft.fasta --merge-reference-sequences

