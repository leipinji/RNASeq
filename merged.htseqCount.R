#!/usr/bin/Rscript
suppressMessages(library(optparse))

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
count<-read.table(file=first_file,sep="\t",header=F,row.names=1)

for (f in files[2:length(files)]){
count_tmp<-read.table(file=f,sep="\t",header=F,row.names=1)
count<-cbind(count,count_tmp)
}
colnames(count)=files
write.table(count,options$output,row.names=T,col.names=NA,sep="\t",quote=F)



