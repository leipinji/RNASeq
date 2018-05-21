#!/usr/bin/Rscript
### options and help message
library("optparse")
option_list=list(
  make_option(c('-G','--GO'),
              type='character',
              default=NULL,
              help='GO analysis file from DAVID,txt format',
              metavar="character"),
  make_option(c('-T','--fpkm'),
type='character',
default=NULL,
help='RNA-Seq fpkm file contain gene expression level. 
              First column should be geneSymbol and 
              the rest columns are samples.',
metavar='character')
)
opt_parse=OptionParser(option_list=option_list)
options=parse_args(opt_parse)
if(is.null(options$GO)){
  print_help(opt_parse)
  stop('GO analysis file should be given.n',call.=F)
}

### main script
library(pheatmap)
.simpleCap=function(x){
  tmp=strsplit(x," ")
  paste(toupper(substring(tmp,1,1)),tolower(substring(tmp,2)),sep="",collapse = " ")
}
fpkm=options$fpkm
BP=options$GO
total_fpkm=read.table(file=fpkm,header = T,sep = "\t",quote = "",row.names = 1)
BP=read.table(file=BP,header=T,sep="\t",quote="")
BP_term=unlist(strsplit(as.vector(BP$Term),split = "~"))[seq(2,length(BP$Term)*2,by=2)]
#cat(paste(BP_term,rep('',length(BP_term)),sep = '\n'))
BP_genes=BP$Genes[1:length(BP_term)]
BP_genes_list=sapply(BP_genes,FUN = function(x){strsplit(as.vector(x),split = ", ")})
for (i in 1:20){
  term = BP_term[i]
  genes=unlist(BP_genes_list[i])
  genes=unlist(lapply(genes,.simpleCap))
  genes_fpkm=subset(total_fpkm,subset = rownames(total_fpkm) %in% genes)
  #rownames(genes_fpkm)=genes_fpkm[,1]
  png(file=paste(term,'png',sep = "."),height = 10,width = 6,res = 300,units = 'in')
  pheatmap(log2(genes_fpkm+1),cluster_rows = T,scale = 'none',cluster_cols = F,color = colorRampPalette(c('green','black','red'))(100),border_color = 'black', main = term,fontsize_row=floor(500/(length(genes_fpkm[,1]))),fontsize=15,cellwidth = 50)
  dev.off()
}

  
