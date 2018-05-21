#!/bin/bash
#########################
#
#  RNASeq_saturation.sh
#
#  Author: Lei Pinji
#
#########################
bam=$1
bed=$2
output=$3
if [ $# -lt 3 ]; then
    echo "Usage $0 [bam] [reference bed] [output]"
    echo "#######"
    exit 0
fi
# geneBody coverage
geneBody_coverage.py -i $bam -r $bed -o $output
junction_saturation.py -i $bam -r $bed -o $output
read_quality.py -i $bam -o $output
RPKM_saturation.py -i $bam -r $bed -o $output
read_NVC.py -i $bam -o $output
