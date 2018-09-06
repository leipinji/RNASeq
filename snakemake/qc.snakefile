configfile: "./config.yaml"

DIR = config['DIR']
SAMPLE = config['SAMPLE']

rule all:
	input:
		expand('{dir}/{sample}_clean_R1.fastq.gz',dir=DIR,sample=SAMPLE),
		expand('{dir}/{sample}_clean_R2.fastq.gz',dir=DIR,sample=SAMPLE)

rule qc:
	input:
		fastq_R1 = "{dir}/{sample}_R1.fastq.gz",
		fastq_R2 = "{dir}/{sample}_R2.fastq.gz"
	output:
		clean_R1 = "{dir}/{sample}_clean_R1.fastq.gz",
		clean_R2 = "{dir}/{sample}_clean_R2.fastq.gz",
		log = "{dir}/{sample}_cutadapt.log"
	shell:
		"cutadapt_PE.sh {input.fastq_R1} {input.fastq_R2} {output.clean_R1} {output.clean_R2} > {output.log} 2>&1"



