configfile: "config.yaml"

import os
import glob

# Edit this path
SAMPLES = "/path/to/Yeast_mutator_analysis/NGS_data/*"
SAMPLES = sorted([os.path.splitext(val)[0] for val in (glob.glob(SAMPLES))]) #Remove .gz from filename path
SAMPLES = [os.path.splitext(val)[0] for val in SAMPLES]
SAMPLES = [os.path.basename(val) for val in SAMPLES]

for i, s in enumerate(SAMPLES):
    SAMPLES[i] = SAMPLES[i][:-12] # Remove _1 or _2 suffix for paired-end reads

SAMPLES = list(set(SAMPLES))

rule all:
    input:
        "calls/mpileup.tsv"

rule NG_merge:
    input:
        R1 = config["paths"]["raw_reads"] + "{sample}_L001_R1_001.fastq.gz",
        R2 = config["paths"]["raw_reads"] + "{sample}_L001_R2_001.fastq.gz"
    output:
        merged = "merged_reads/" + "{sample}_merged.fastq.gz"
    shell:
        "NGmerge -n 8 -p 0 -q 33 -u 40 "
        "-1 {input.R1} -2 {input.R2} "
        "-o {output.merged} "
        
rule bwa_map:
    input:
        template = config["paths"]["template"] + "template.fa",
        merged = "merged_reads/" + "{sample}_merged.fastq.gz"
    output:
        "mapped_reads/{sample}.bam"
    shell:
        "bwa mem -t 4 {input.template} {input.merged} | "
        "samtools view -Sb - > {output}"

rule samtools_sort:
    input:
        "mapped_reads/{sample}.bam"
    output:
        "sorted_reads/{sample}.bam"
    shell:
        "samtools sort -T sorted_reads/{wildcards.sample} "
        "-O bam {input} > {output}"

rule samtools_index:
    input:
        "sorted_reads/{sample}.bam"
    output:
        "sorted_reads/{sample}.bam.bai"
    shell:
        "samtools index {input}"

rule samtools_mpileup:
    input:
        fa = config["paths"]["template"] + "template.fa",
        bam = expand("sorted_reads/{sample}.bam", sample=SAMPLES),
        bai = expand("sorted_reads/{sample}.bam.bai", sample=SAMPLES)
    output:
        "calls/mpileup.tsv"
    shell:
        "bcftools mpileup --max-depth 600000 -O v -a FORMAT/AD -f {input.fa} {input.bam} > {output}" # Setting max-depth to 0 allows INF reads at each genomic position.

#"freebayes --min-alternate-count 1 --min-alternate-fraction 0 -f {input.fa} --ploidy 1 {input.bam} > calls/all.vcf"
#"freebayes -f {input.fa} --ploidy 1 {input.bam} > all.vcf"
#"bcftools mpileup --max-depth 200000 -Ou -f {input.fa} {input.bam} | bcftools call --ploidy 1 -p 1 -cv - > {output}"
