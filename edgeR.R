#!/usr/bin/Rscript
suppressMessages(library(optparse))
library('edgeR')
options<-OptionParser()
options<-add_option(options,
                   opt_str = c('-c','--count'),
                   action = 'store',
                   type = 'character',
                   help = 'Reads count table in integer. \n Each row represent a gene and each column represent a sample.' )
options<-add_option(options,
                   opt_str = c('-g','--group'),
                   action = 'store',
                   type = 'character',
                   help = 'Group factor for samples. \n Should be seperated by comma.')
options<-add_option(options,
                   opt_str = c('-p','--pvalue'),
                   action = 'store',
                   type = 'double',
                   default = 0.05,
                   help = 'P value cutoff for differential expression gene analysis.')
options<-add_option(options,
                   opt_str = c('-f','--fold'),
                   action = 'store',
                   type = 'integer',
                   default = 2,
                   help = 'Fold change cutoff for differential expression gene analysis')

options=parse_args(options)

count<-read.table(file=options$count,header=T,row.names = 1,sep = "\t")
group<-options$group
group<-unlist(strsplit(group))


