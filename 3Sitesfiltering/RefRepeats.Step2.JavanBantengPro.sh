python3 extSoftRepetFA.py Banteng_PlusMt.draft.fasta.masked > Banteng_PlusMt.draft.fasta.masked.repeat.bed
/home/users/xi/software/bedtools2/bin/bedtools subtract -a DefassaWaterbuck.Ref.scaffolds.all.bed -b DefassaWaterbuck.fasta.masked.repeat.bed > DefassaWaterbuck.fasta.masked.NOrepeat.bed

####I used RepeatMasker4.1.5 with RepBase library  RMBlast
