#!/usr/bin/Rscript
suppressMessages(library(optparse))
options(warn=-1)

options<-OptionParser()
options<-add_option(options,
	opt_str = c('-f','--files'),
	action = 'store',
	type = 'character',
	help = 'Htseq-count output files used to merged into a single table')
options<-add_option(options,
	opt_str = c('-o','--output'),
	action = 'store',
	type = 'character',
	help = 'output file name'
	)

options<-parse_args(options)
filename<-options$files
files<-unlist(strsplit(filename,","))
# first file name
first_file=files[1]
count<-read.table(file=first_file,sep="\t",header=F)

for (f in files[2:length(files)]){
count_tmp<-read.table(file=f,sep="\t",header=F)
count<-merge(count,count_tmp,by=1,all=T,sort=F)
}
colnames(count)=c('Gene_name',files)
write.table(count,options$output,row.names=F,col.names=T,sep="\t",quote=F)



