#!/usr/bin/Rscript
library(RColorBrewer)
col_pallete=brewer.pal(8,"Dark2")
options=commandArgs(trailingOnly = T)
sheet=options[1]
col=as.numeric(options[2])
col=col_pallete[col]
main=options[3]
GO=read.table(file=sheet,header = T,sep="\t",quote="")
GO_term=GO$Term
GO_pvalue=GO$PValue
GO_term_top25=unlist(strsplit(as.vector(GO_term),split = ":"))[seq(2,20,by=2)]
GO_pvalue=-log10(GO_pvalue)[1:10]
for (index in 1:10){
    GO_term_top25[index]=substr(GO_term_top25[index],1,50)
    }
png(file=paste(main,"png",sep="."),height = 5.38,width = 10.81,units = 'in',res=300)
par(mar=c(5,35,3,3))
barplot(rev(GO_pvalue),horiz=T,col = col,las=1,names.arg = rev(GO_term_top25),cex.axis = 2,lwd=3,main = main,cex.main=1.5,cex.names = 1.5,space = 0.618)
mtext(side = 1,text='-log10(P Value)',cex=2,line = 3)
dev.off()
