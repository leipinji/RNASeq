#!/usr/bin/Rscript
suppressMessages(library(optparse))
options=OptionParser()
options=add_option(options,
                    opt_str = c('-F','--fpkm'),
                    action = 'store',
                    type = 'character',
                    help = 'fpkm value matrix from TCGA')
options=add_option(options,
                    opt_str = c('-o','--output'),
                    action = 'store',
                    type = 'character',
                    help = 'output file name')
options=parse_args(options)

fpkm<-read.table(file = options$fpkm,header = T,sep="\t")
group<-fpkm$GeneSymbol
fpkm<-fpkm[,c(3,4)]
fpkm_sum<-rowsum(fpkm,group = group,reorder = T)
group_order<-sort(unique(group))
fpkm_sum[,3]<-group_order
#fpkm_sum<-fpkm_sum[,c(3,1,2)]
fpkm_sum<-fpkm_sum[,c(3,1)]
colnames(fpkm_sum)<-c('Gene_name','FPKM')
write.table(fpkm_sum,file = options$output,col.names = T,row.names=F,sep = "\t",quote = F,na = 'NA')
