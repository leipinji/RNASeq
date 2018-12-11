configfile: "snakemake/config.yaml"

SAMPLE = config['SAMPLE']

rule all:
	input:
		expand('clean/{sample}_clean_R1.fastq.gz',sample=SAMPLE),
		expand('clean/{sample}_clean_R2.fastq.gz',sample=SAMPLE)

rule qc:
	input:
		fastq_R1 = "samples/{sample}_R1_001.fastq.gz",
		fastq_R2 = "samples/{sample}_R2_001.fastq.gz"
	output:
		clean_R1 = "clean/{sample}_clean_R1.fastq.gz",
		clean_R2 = "clean/{sample}_clean_R2.fastq.gz",
		log = "log/{sample}_cutadapt.log"
	shell:
		"cutadapt_PE.sh {input.fastq_R1} {input.fastq_R2} {output.clean_R1} {output.clean_R2} > {output.log} 2>&1"



