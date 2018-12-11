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
    echo "cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -m 20 -o R1.clean.fastq -p R2.clean.fastq R1.raw.fastq R2.raw.fastq"
    exit 0
fi
### quality control of raw data
fastqc $R1
fastqc $R2

### raw data filter
cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -m 20 -o $R1_cut -p $R2_cut $R1 $R2

### quality control of clean data 
fastqc $R1_cut
fastqc $R2_cut

### clean data compress
gzip $R1_cut
gzip $R2_cut








