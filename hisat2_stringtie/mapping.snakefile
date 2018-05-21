configfile: "config.yaml"

rule all:
	input:
		expand("mapped/{sample}.sorted.bam.bai",sample=config['SAMPLE'])


rule hisat_mapping:
	input:
		fastq_r1 = "sample/{sample}_clean_R1.fastq.gz",
		fastq_r2 = "sample/{sample}_clean_R2.fastq.gz"

	output:
		bam = "mapped/{sample}.bam"
	params:
		index = config['index'],
		threads = config['threads']
		
	shell:
		"hisat2 -q --phred33 -p {params.threads} -x {params.index} -1 {input.fastq_r1} -2 {input.fastq_r2} | samtools view -Sb - > {output}"


rule samtools_sort:
	input:
		bam = "mapped/{sample}.bam"
	output:
		sorted_bam = "mapped/{sample}.sorted.bam"
	shell:
		"samtools sort -O bam {input} -o {output}"

rule samtools_index:
	input:
		sorted_bam = "mapped/{sample}.sorted.bam"
	output:
		index_bam = "mapped/{sample}.sorted.bam.bai"
	shell:
		"samtools index {input}"


