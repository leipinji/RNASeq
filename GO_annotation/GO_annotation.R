#!/usr/bin/Rscript
suppressMessages(library(optparse))
#suppressMessages(library(biomaRt))
#suppressMessages(library(GOstats))
#suppressMessages(library(org.Rn.eg.db))
#suppressMessages(library(org.Hs.eg.db))
#suppressMessages(library(org.Mm.eg.db))
#suppressMessages(library(KEGG.db))
options=OptionParser()
options=add_option(options,
                   opt_str = c('-w','--org'),
                   action = 'store',
                   type = 'character',
                   help = 'Organism for annotation, eg.
                   Hs for human,
                   Mm for mouse,
                   Rn for Rat'
)

options=add_option(options,
                   opt_str = c('-g','--genes'),
                   action = 'store',
                   type = 'character',
                   help = 'Gene list for annotation, we expect official genesymbol'
                   )

options=parse_args(options)

suppressMessages(library(biomaRt))
suppressMessages(library(GOstats))
suppressMessages(library(org.Rn.eg.db))
suppressMessages(library(org.Hs.eg.db))
suppressMessages(library(org.Mm.eg.db))
suppressMessages(library(KEGG.db))

## human
if (options$org == 'Hs'){
  ensembl=useMart(biomart = 'ENSEMBL_MART_ENSEMBL')
  human=useDataset(mart = ensembl,dataset ='hsapiens_gene_ensembl')
  GO=getBM(attributes = c('go_id','source','entrezgene'),filters = 'with_go',values=T,mart = human)
  entrezUniverse=unique(GO$entrezgene)
  selectedIDs=read.table(file=options$genes,header = F,sep="\t")
  selectedIDs=as.vector(selectedIDs[,1])
  selectedIDs=getBM(attributes = 'entrezgene',filters ='hgnc_symbol',values = selectedIDs,mart = human)
  selectedIDs=selectedIDs[,1]
  params_BP=new('GOHyperGParams',
             geneIds=selectedIDs,
             universeGeneIds=entrezUniverse,
             annotation='org.Hs.eg.db',
             ontology='BP',
             pvalueCutoff=0.05,
             conditional=T,
             testDirection='over'
  )
  
  params_CC=new('GOHyperGParams',
                geneIds=selectedIDs,
                universeGeneIds=entrezUniverse,
                annotation='org.Hs.eg.db',
                ontology='CC',
                pvalueCutoff=0.05,
                conditional=T,
                testDirection='over'
  )
  
  params_MF=new('GOHyperGParams',
                geneIds=selectedIDs,
                universeGeneIds=entrezUniverse,
                annotation='org.Hs.eg.db',
                ontology='MF',
                pvalueCutoff=0.05,
                conditional=T,
                testDirection='over'
  )
  
  params_KEGG=new('KEGGHyperGParams',
                  geneIds=selectedIDs,
                  universeGeneIds=entrezUniverse,
                  annotation='org.Hs.eg.db',
                  pvalueCutoff=0.05,
                  testDirection='over'
  )
  
  hgOver_BP=hyperGTest(params_BP)
  hgOver_CC=hyperGTest(params_CC)
  hgOver_MF=hyperGTest(params_MF)
  hgOver_KEGG=hyperGTest(params_KEGG)
  BP=summary(hgOver_BP)
  CC=summary(hgOver_CC)
  MF=summary(hgOver_MF)
  KEGG=summary(hgOver_KEGG)
  htmlReport(hgOver_BP,file = 'BP.html')
  htmlReport(hgOver_CC,file = 'CC.html')
  htmlReport(hgOver_MF,file = 'MF.html')
  htmlReport(hgOver_KEGG,file = 'KEGG.html')
  write.table(BP,file = 'BP.txt',col.names = T,sep="\t",quote = F,row.names = F)
  write.table(CC,file = 'CC.txt',col.names = T,sep="\t",quote = F,row.names = F)
  write.table(MF,file = 'MF.txt',col.names = T,sep="\t",quote = F,row.names = F)
  write.table(KEGG,file = 'KEGG.txt',col.names = T,sep='\t',quote = F,row.names = F)
}


## rat

if (options$org == 'Rn'){
  ensembl=useMart(biomart = 'ENSEMBL_MART_ENSEMBL')
  rat=useDataset(mart = ensembl,dataset ='rnorvegicus_gene_ensembl')
  GO=getBM(attributes = c('go_id','source','entrezgene'),filters = 'with_go',values=T,mart = rat)
  entrezUniverse=unique(GO$entrezgene)
  selectedIDs=read.table(file=options$genes,header = F,sep="\t")
  selectedIDs=as.vector(selectedIDs[,1])
  selectedIDs=getBM(attributes = 'entrezgene',filters ='rgd_symbol',values = selectedIDs,mart = rat)
  selectedIDs=selectedIDs[,1]
  params_BP=new('GOHyperGParams',
                geneIds=selectedIDs,
                universeGeneIds=entrezUniverse,
                annotation='org.Rn.eg.db',
                ontology='BP',
                pvalueCutoff=0.05,
                conditional=T,
                testDirection='over'
  )
  
  params_CC=new('GOHyperGParams',
                geneIds=selectedIDs,
                universeGeneIds=entrezUniverse,
                annotation='org.Rn.eg.db',
                ontology='CC',
                pvalueCutoff=0.05,
                conditional=T,
                testDirection='over'
  )
  
  params_MF=new('GOHyperGParams',
                geneIds=selectedIDs,
                universeGeneIds=entrezUniverse,
                annotation='org.Rn.eg.db',
                ontology='MF',
                pvalueCutoff=0.05,
                conditional=T,
                testDirection='over'
  )
  
  params_KEGG=new('KEGGHyperGParams',
                  geneIds=selectedIDs,
                  universeGeneIds=entrezUniverse,
                  annotation='org.Rn.eg.db',
                  pvalueCutoff=0.05,
                  testDirection='over'
  )
  
  hgOver_BP=hyperGTest(params_BP)
  hgOver_CC=hyperGTest(params_CC)
  hgOver_MF=hyperGTest(params_MF)
  hgOver_KEGG=hyperGTest(params_KEGG)
  BP=summary(hgOver_BP)
  CC=summary(hgOver_CC)
  MF=summary(hgOver_MF)
  KEGG=summary(hgOver_KEGG)
  htmlReport(hgOver_BP,file = 'BP.html')
  htmlReport(hgOver_CC,file = 'CC.html')
  htmlReport(hgOver_MF,file = 'MF.html')
  htmlReport(hgOver_KEGG,file = 'KEGG.html')
  write.table(BP,file = 'BP.txt',col.names = T,sep="\t",quote = F,row.names = F)
  write.table(CC,file = 'CC.txt',col.names = T,sep="\t",quote = F,row.names = F)
  write.table(MF,file = 'MF.txt',col.names = T,sep="\t",quote = F,row.names = F)
  write.table(KEGG,file = 'KEGG.txt',col.names = T,sep='\t',quote = F,row.names = F)
}




## mouse

if (options$org == 'Mm'){
  ensembl=useMart(biomart = 'ENSEMBL_MART_ENSEMBL')
  mouse=useDataset(mart = ensembl,dataset ='mmusculus_gene_ensembl')
  GO=getBM(attributes = c('go_id','source','entrezgene'),filters = 'with_go',values=T,mart = mouse)
  entrezUniverse=unique(GO$entrezgene)
  selectedIDs=read.table(file=options$genes,header = F,sep="\t")
  selectedIDs=as.vector(selectedIDs[,1])
  selectedIDs=getBM(attributes = 'entrezgene',filters ='mgi_symbol',values = selectedIDs,mart = mouse)
  selectedIDs=selectedIDs[,1]
  params_BP=new('GOHyperGParams',
                geneIds=selectedIDs,
                universeGeneIds=entrezUniverse,
                annotation='org.Mm.eg.db',
                ontology='BP',
                pvalueCutoff=0.05,
                conditional=T,
                testDirection='over'
  )
  
  params_CC=new('GOHyperGParams',
                geneIds=selectedIDs,
                universeGeneIds=entrezUniverse,
                annotation='org.Mm.eg.db',
                ontology='CC',
                pvalueCutoff=0.05,
                conditional=T,
                testDirection='over'
  )
  
  params_MF=new('GOHyperGParams',
                geneIds=selectedIDs,
                universeGeneIds=entrezUniverse,
                annotation='org.Mm.eg.db',
                ontology='MF',
                pvalueCutoff=0.05,
                conditional=T,
                testDirection='over'
  )
  
  params_KEGG=new('KEGGHyperGParams',
                  geneIds=selectedIDs,
                  universeGeneIds=entrezUniverse,
                  annotation='org.Mm.eg.db',
                  pvalueCutoff=0.05,
                  testDirection='over'
  )
  
  hgOver_BP=hyperGTest(params_BP)
  hgOver_CC=hyperGTest(params_CC)
  hgOver_MF=hyperGTest(params_MF)
  hgOver_KEGG=hyperGTest(params_KEGG)
  BP=summary(hgOver_BP)
  CC=summary(hgOver_CC)
  MF=summary(hgOver_MF)
  KEGG=summary(hgOver_KEGG)
  htmlReport(hgOver_BP,file = 'BP.html')
  htmlReport(hgOver_CC,file = 'CC.html')
  htmlReport(hgOver_MF,file = 'MF.html')
  htmlReport(hgOver_KEGG,file = 'KEGG.html')
  write.table(BP,file = 'BP.txt',col.names = T,sep="\t",quote = F,row.names = F)
  write.table(CC,file = 'CC.txt',col.names = T,sep="\t",quote = F,row.names = F)
  write.table(MF,file = 'MF.txt',col.names = T,sep="\t",quote = F,row.names = F)
  write.table(KEGG,file = 'KEGG.txt',col.names = T,sep='\t',quote = F,row.names = F)
}

