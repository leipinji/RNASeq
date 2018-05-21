#!/usr/bin/perl
# File name : KEGG_pathway_image.pl
#Author: Lei Pinji
#Mail: LPJ@whu.edu.cn
###############################
use warnings;
use strict;
use Getopt::Long;
my %opt;

GetOptions (\%opt,
"help",
"pathway=s",
"output=s",
"RNASeq",
"ChIPSeq",
"deg=s",
);

if (defined $opt{'help'}) {
	print<<EOF;
	Usage:	$0	[options*]	-pathway <KEGG pathway>		-o <output KEGG weblink>	
	Description:
	Fetch KEGG weblink of significant enriched pathway
	KEGG pathway file : DAVID output format

	Options:
	-help:	print this help message.
	-pathway:	DAVID output kegg pathway.
	-output:	output KEGG weblink file.
	-RNASeq:	fetch for RNASeq DEGs KEGG pathway. Up regulated genes in red and Down regulated genes in steelblue.
	-deg:		for RNASeq KEGG pathway differential expression gene file should be given.
	-ChIPSeq:	fetch for ChIPSeq target genes KEGG pathway. target genes in red.

	differential expression gene format
	#geneSymbol	sample1	sample2	fold
##################################
EOF
exit(0);
}
# RNASeq DEGS
open my $RNASeq_fh, "<", $opt{'deg'} or die;
my %deg;
while (<$RNASeq_fh>) {
	chomp;
	next if /^#/;
	my ($geneSymbol,$sample1,$sample2,$fold) = split/\t/;
	$deg{uc($geneSymbol)} = $fold;
	}

open my $pathway_fh, "<",$opt{'pathway'} or die;
open my $output_fh, ">",$opt{'output'} or die;
<$pathway_fh>;	# headline of pathway file

while (<$pathway_fh>) {
	chomp;
	my @tmp = split/\t/;
	my ($term,$count,$pvalue,$genes) = @tmp[1,2,4,5];
	# Term:	hsa04530:Tight Junction
	# Genes: PARD6A,ACTG1,PPP2R1B...
	my ($hsa,$pathway_name) = split/:/,$term;
	my @genes_name = split/,\s/,$genes;
    $hsa =~ s/[a-z]*([0-9]*)/map$1/;
	my $kegg_link = "http://www.kegg.jp/kegg-bin/show_pathway?$hsa/";
	# ChIPSeq gene color
	my $genes_name_color;
	if (defined $opt{'ChIPSeq'}) {
	my $bgcolor="red";
	$genes_name_color=join("%09$bgcolor/",@genes_name,'');
	}
	# RNASeq gene color
	if (defined $opt{'RNASeq'}) {
	my $bgcolor;
	my @gene_color;
	for (@genes_name) {
		if ($deg{$_} < 0) {
			$bgcolor = "cyan";
			}
		elsif ($deg{$_} > 0) {
			$bgcolor = "red";
			}
	my $tmp_gene_color = $_."%09".$bgcolor;
	push @gene_color, $tmp_gene_color;
		}
	$genes_name_color = join("/",@gene_color);
	}
	my $weblink = $kegg_link.$genes_name_color;
	my $hsa_html = $hsa.".html";
	system("wget -O $hsa_html $weblink");
	open my $hsa_html_fh,"<",$hsa_html or die;
	while (<$hsa_html_fh>) {
		if (/^<img\s*src="(.*.png)"\s*name="pathwayimage".*/){
		my $image_link = "http://www.kegg.jp$1";
		system("wget $image_link");
		}
	}
	close $hsa_html_fh;
	unlink("$hsa_html");
	print $output_fh $weblink,"\n";
}

	




