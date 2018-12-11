#!/home/teamlymphatics/miniconda3/bin/python
########################
#
#  RNASeq_parse_gff.py
#
#  Author: Lei Pinji
#
########################
import sys
import re

gff = sys.argv[1]
file = open(gff,'r')
print ("\t".join(("GeneSymbol","Transcript","FPKM","TPM")))

for line in file.readlines():
    line = line.strip("\n")
    line_match = re.match(r"^#",line)
    if line_match:
        continue
    line_col = line.split("\t")
    if line_col[2] == 'transcript':
        # attribute column
        attr = line_col[8]
        attr_list = attr.split("; ")
        # gene
        gene_name = attr_list[0]
        m = re.match(r'gene_id."(.*)"',gene_name)
        gene_name = m[1]
        # transcript
        transcript_name = attr_list[1]
        m = re.match(r'transcript_id."(.*)"',transcript_name)
        transcript_name = m[1]
        # FPKM
        fpkm = attr_list[4]
        m = re.match(r'FPKM."(.*)"',fpkm)
        fpkm= m[1]
        # TPM
        tpm = attr_list[5]
        m = re.match(r'TPM."(.*)"',tpm)
        tpm = m[1]
        print ("\t".join((gene_name,transcript_name,fpkm,tpm)))
