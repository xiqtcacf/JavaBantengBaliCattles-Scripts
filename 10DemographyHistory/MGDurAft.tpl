//Parameters for the coalescence simulation program : fsimcoal2.exe
2 samples to simulate :
//Population effective sizes (number of genes)
NPOPW
NPOPB
//Samples sizes and samples age
10
54
//Growth rates  : negative growth implies population expansion
0
0
//Number of migration matrices : 0 implies no migration between demes
3
//Migration matrix 0
0 mBW1
mWB1 0
//Migration matrix 1
0 mBW2
mWB2 0
//Migration matrix 2
0 0
0 0
//historical event: time, source, sink, migrants, new deme size, new growth rate, migration matrix index
3  historical event
TDOME 1 1 0 RES2 0 1
TDOMS 1 1 0 RES3 0 2
TDIV  0 1 1 RES4 0 2
//Number of independent loci [chromosome]
1 0
//Per chromosome: Number of contiguous linkage Block: a block is a set of contiguous loci
1
//per Block:data type, number of loci, per generation recombination and mutation rates and optional parameters
FREQ  1   0   1.26e-8  OUTEXP
