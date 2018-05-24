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

# count table
count<-read.table(file=options$count,header=T,row.names = 1,sep = "\t")
# group factor
group<-options$group
group<-unlist(strsplit(group,split=","))
# DGE list
cds<-DGEList(count=count,group = group)
# data filter
keep<-rowSums(cpm(cds) >=10) >=2
cds<-cds[keep,]
# reset library size
cds$samples$lib.size<-colSums(cds$counts)
# normalizing the data
cds<-calcNormFactors(cds)
# estimating the dispersion
cds<-estimateCommonDisp(cds,verbose=T)
cds<-estimateTagwiseDisp(cds)
# differential expression analysis
pair<-unique(group)
results<-exactTest(cds,pair=pair)
results_fpkm<-topTags(results,n=length(cds$counts[,1]))
#results_fpkm<-topTags(results,n=100)
output_file=paste(c(pair,"gene_expression_pvalue_foldChange.txt"),collapse="_")
write.table(results_fpkm,file = output_file,sep="\t",col.names = NA,row.names = T,quote = F)




