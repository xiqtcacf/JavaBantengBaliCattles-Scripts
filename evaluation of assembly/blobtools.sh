###
blobtools add --busco Banteng_PlusMt/Banteng_PlusMt.cetartiodactyla/run_cetartiodactyla_odb10/full_table.tsv --fasta ./Banteng_PlusMt/Banteng_PlusMt.fasta ./BantengAssemblyPlotting
###plotting
blobtools view --format png --plot --view snail ./BantengAssemblyPlotting
