#!/usr/bin/Rscript
library(RColorBrewer)
col_pallete=brewer.pal(8,"Dark2")
options=commandArgs(trailingOnly = T)
sheet=options[1]
col=as.numeric(options[2])
#print(col)
col=col_pallete[col]
#print(col)
main=options[3]
GO=read.table(file=sheet,header = T,sep="\t",quote="")
GO_term=GO$Term
GO_pvalue=GO$PValue
GO_term_top25=unlist(strsplit(as.vector(GO_term),split = "~"))[seq(2,40,by=2)]
GO_pvalue=-log10(GO_pvalue)[1:20]
for (index in 1:20){
    GO_term_top25[index]=substr(GO_term_top25[index],1,50)
    GO_term_top25=paste0(toupper(substr(GO_term_top25,1,1)),substr(GO_term_top25,2,nchar(GO_term_top25)),sep='')
}
#left_margin=max(length(unlist(strsplit(GO_term_top25,split=""))))
png(file=paste(main,"png",sep="."),height = 8,width = 12,unit='in',res=300)
par(mar=c(4,35,3,3))
barplot(rev(GO_pvalue),horiz=T,col = col,las=1,names.arg = rev(GO_term_top25),cex.axis = 2,lwd=3,main = main,cex.main=1.5,cex.names = 1.5,space = 0.618)
mtext(side = 1,text='-log10(P Value)',cex=2,line = 2.5)
dev.off()
