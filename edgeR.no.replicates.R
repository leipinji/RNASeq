#!/home/teamlymphatics/miniconda3/envs/python3/bin/Rscript
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
# at least one sample count per million value > 10
keep<-rowSums(cpm(cds) >=10) >=1
cds<-cds[keep,]
# reset library size
cds$samples$lib.size<-colSums(cds$counts)
# normalizing the data
cds<-calcNormFactors(cds)
# estimating the dispersion
#cds<-estimateCommonDisp(cds,verbose=T)
#cds<-estimateTagwiseDisp(cds)
# differential expression analysis
# customized dispersion
bcv<-0.1
pair<-unique(group)
results<-exactTest(cds,dispersion=bcv^2)
results_fpkm<-topTags(results,n=length(cds$counts[,1]))
#results_fpkm<-topTags(results,n=100)
#pvalue=options$pvalue
fold=options$fold
colnames(results_fpkm)
results_fpkm<-as.data.frame(results_fpkm)
deg_fpkm<-subset(results_fpkm,(logFC>= log2(fold))|(logFC <= -log2(fold)))
output_file=paste(c(pair,"gene_expression_pvalue_foldChange.txt"),collapse="_")
deg_file=paste(c(pair,"deg.txt"),collapse="_")
write.table(results_fpkm,file = output_file,sep="\t",col.names = NA,row.names = T,quote = F)
write.table(deg_fpkm,file=deg_file,sep="\t",col.names=NA,row.names=T,quote=F)




