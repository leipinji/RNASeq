configfile: "config.yaml"

rule all:
	input:
		expand("assembled/{sample}.stringtie.gtf",sample=config['SAMPLE'])


rule stringtie_assemble:
	input:
		bam = "mapped/{sample}.sorted.bam"

	output:
		gtf = "assembled/{sample}.stringtie.gtf"
	params:
		gff = config['gff'],
		threads = config['threads']
		
	shell:
		"stringtie -p {params.threads} -G {params.gff} -e -o {output} -l {wildcards.sample} {input}"




