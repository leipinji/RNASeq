configfile: "config.yaml"

rule all:
	input:
		expand("htseqCount/{dir}/{sample}.htseqCount.txt",dir=config['DIR'],sample=config['SAMPLE'])

rule htseqCount:
	input:
		bam = "mapped/{dir}/{sample}.sorted.bam"
	output:
		count = "htseqCount/{dir}/{sample}.htseqCount.txt"
	params:
		gff = config['gff']
	shell:
		"htseq-count -f bam -r name -s no -a 20 -t exon -i gene_id -m union {input} {params.gff} > {output}"





