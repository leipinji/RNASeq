configfile: "config.yaml"

rule all:
	input:
		expand("htseqCount/{sample}.htseqCount.txt",sample=config['SAMPLE'])

rule htseqCount:
	input:
		bam = "mapped/{sample}.sorted.bam"
	output:
		count = "htseqCount/{sample}.htseqCount.txt"
	params:
		gff = config['gff']
	shell:
		"htseq-count -f bam -r name -s no -a 20 -t exon -i gene_name -m union {input} {params.gff} > {output}"
		





