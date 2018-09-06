configfile: "config.yaml"

rule all:
	input:
		expand("fpkm/{dir}/{sample}.fpkm.txt",dir=config['DIR'],sample=config['SAMPLE']),
#		"fpkm/fpkm.count.table.txt"

rule tx_fpkm:
	input:
		gtf = "assembled/{dir}/{sample}.stringtie.gtf"
	output:
		fpkm = "fpkm/{dir}/{sample}.transcript.fpkm.txt"
	shell:
		"RNASeq_parse_gff.py {input} > {output}"

rule fpkm:
	input:
		transcript = "fpkm/{dir}/{sample}.transcript.fpkm.txt"
	output:
		fpkm = "fpkm/{dir}/{sample}.fpkm.txt"
	shell:
		"RNASeq_symbol_fpkm_sum.R -F {input} -o {output}"

#rule table:
#	input:
#		expand("fpkm/{dir}/{sample}.fpkm.txt",dir=config['DIR'],sample=config['SAMPLE'])
#	output:
#		"fpkm/fpkm.count.table.txt"
#	shell:
#		"merged.htseqCount.R -f {input} -o {output}"
