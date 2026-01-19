"""
snakemake to do genotype likelihood by angsd
configfile needs:
       - bams: file with full path to all bamfile. 
       - chroms: path to file with list of chromosomes to use
       - sites_filtering_region: path to sites_filtering_region
       - outmain: path to main output
       - params:
                - angsd: minQ: value
                         minMapQ: value

      - scriptsdir: path to directory with requried scripts
"""

ANGSD="/maps/projects/bos/apps/angsd/angsd"

OUTMAIN=config["outmain"]

CHROMLIST=config["chroms"]
with open(CHROMLIST, "r") as fh:
    CHROMS=[x.rstrip() for x in fh.readlines()]


# LOAD PARAMS
MINQ=config["params"]["angsd"]["minQ"]
MINMAPQ=config["params"]["angsd"]["minMapQ"]


rule all:
    input:
        os.path.join(OUTMAIN, "beagle", "all.beagle.gz")
        #os.path.join(OUTMAIN, "something")

#rule do_bamlist:
#    """extract path to bam files from info file"""
#    input:
#        info = config["info"]
#    output:
#        bamlist = os.path.join(OUTMAIN, "info", "bams.list")
#    shell:"""
#    cut -f1 {input.info} > {output.bamlist}
#"""

rule do_beagle_perchrom:
    """estiamte genotype likelihoods per chromosome"""
    input:
        bams = config["bams"],
        regions = config["regions"]
    output:
        bgl = temp(os.path.join(OUTMAIN, "beagle", "{chrom}.beagle.gz")),
        maf = temp(os.path.join(OUTMAIN, "beagle", "{chrom}.mafs.gz"))
    log: os.path.join(OUTMAIN, "beagle", "{chrom}.arg")
    params:
        outprefix = os.path.join(OUTMAIN, "beagle", "{chrom}"),
        r = "{chrom}"
    shell:"""
    {ANGSD} -GL 2 -bam {input.bams} -sites {input.regions} -r '{params.r}' -out '{params.outprefix}' -minMapQ {MINMAPQ} -minQ {MINQ} -doGlf 2 -doMajorMinor 1 -doMaf 1 -SNP_pval 1e-6 -minMaf 0.05
"""

rule concat_beagle:
    """put together genotype likelihood chromosome fiels into a single file"""
    input:
        expand(os.path.join(OUTMAIN, "beagle", "{chrom}.beagle.gz"), chrom=CHROMS)
    output:
        bgl = os.path.join(OUTMAIN, "beagle", "all.beagle.gz")
    params:
        indir=os.path.join(OUTMAIN, "beagle"),
        outprefix = os.path.join(OUTMAIN, "beagle", "all")
    log: os.path.join(OUTMAIN, "beagle", "all.arg")
    run:
        c = CHROMS[0]
        shell("zcat {params.indir}/'{c}'.beagle.gz | awk 'NR==1' > {params.outprefix}.beagle") # need awk shit bc head -1 makes snakemake fail
        for c in CHROMS:
            shell("zcat {params.indir}/'{c}'.beagle.gz | sed 1d >> {params.outprefix}.beagle")
            shell("cat {params.indir}/'{c}'.arg >> {params.outprefix}.arg")
        shell("gzip {params.outprefix}.beagle")

