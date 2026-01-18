python3 XiaodongLiuWritten.extSoftRepeatFA.py Banteng_PlusMt.draft.fasta.masked > Banteng_PlusMt.draft.fasta.masked.repeat.bed
/home/users/xi/software/bedtools2/bin/bedtools subtract -a DefassaWaterbuck.Ref.scaffolds.all.bed -b DefassaWaterbuck.fasta.masked.repeat.bed > DefassaWaterbuck.fasta.masked.NOrepeat.bed

python3 XiaodongLiuWritten.extSoftRepeatFA.py water_buffalo.reference.fna.masked > water_buffalo.reference.fna.masked.repeat.bed
/home/users/xi/software/bedtools2/bin/bedtools subtract -a water_buffalo.reference.fna.fai.bed -b water_buffalo.reference.fna.masked.repeat.bed > water_buffalo.reference.fna.masked.NOrepeat.bed
