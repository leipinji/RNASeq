#!/usr/bin/Rscript
suppressMessages(library(optparse))

options<-OptionParser()
options<-add_option(options,
		    opt_str = c('-b','--bp'),
		    action = 'store',
		    type = 'character',
		    help = "GO Biological Processes"
		    )

options<-add_option(options,
		    opt_str = c('-c','--color'),
		    action = 'store',
		    type = 'character',
		    help = "Color for dotPlot"
		    )
options<-add_option(options,
		    opt_str = c('-f','--file'),
		    action = 'store',
		    type = 'character',
		    help = 'file name for picture'
		    )

options<-parse_args(options)

suppressMessages(library(dplyr))
suppressMessages(library(ggplot2))
suppressMessages(library(tidyr))

### GO functional analysis Biological Processes

GO<-read.table(file = options$bp,header = T,sep = "\t")
pvalue_adj<--log10(GO$Bonferroni)
GO$pvalue_adj<-pvalue_adj
GO_top10<-GO[1:10,]
GO_top10<-GO_top10 %>%
  mutate(Term = factor(Term,levels = .$Term))
png(filename = options$file,height = 3.2,width = 5.12,units = 'in',res = 300)
theme_set(theme_classic())
ggplot(GO_top10,aes(x=reorder(Term,pvalue_adj),y=pvalue_adj))+
  geom_point(color=options$color,size=3)+
  geom_segment(aes(x=Term,xend=Term,y=min(pvalue_adj),yend=max(pvalue_adj)),linetype="dashed",size=0.1)+
  xlab("Term")+
  ylab("-log10(Bonferroni Pvalue)")+
  coord_flip()
dev.off()




