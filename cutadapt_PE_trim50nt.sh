#!/bin/bash
#########################
#
#  cutadapt_PE.sh
#
#  Author: Lei Pinji
#
#########################
R1=$1
R2=$2
R1_cut=$3
R2_cut=$4
if [[ $# -lt 4 ]];then
    echo "Usage : $0 [R1.fastq.gz] [R2.fastq.gz] [R1 output] [R2 output]"
    echo "Description: remove adaptors for paired end sequence reads"
    exit 0
fi
cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -u 25 -u -25 -U 25 -U -25 -m 30 -o $R1_cut -p $R2_cut $R1 $R2

