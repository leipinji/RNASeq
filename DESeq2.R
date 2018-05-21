#!/usr/bin/Rscript
suppressMessages(library(optparse))
library('DESeq2')
options=OptionParser()
options=add_option(options,
                   opt_str = c('-s1','--control'),
                   action = 'store',
                   type = 'character',
                   help = 'Directory for samples 1' )
options=add_option(options,
                   opt_str = c('-s2','--treat'),
                   action = 'store',
                   type = 'character',
                   help = 'Directory for samples 2')
options=add_option(options,
                   opt_str = c('-l1','--label1'),
                   action = 'store',
                   type = 'character',
                   default = 'control',
                   help = 'Label for first sample')
options=add_option(options,
                   opt_str = c('-l2','--label2'),
                   action = 'store',
                   type = 'character',
                   default = 'treat',
                   help = 'Label for second sample')
options=parse_args(options)


