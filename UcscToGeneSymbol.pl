#!/usr/bin/perl
##>>######################################################
##>> 	Author Name:	Lei Pinji
##>>	Title:	UcscToGeneSymbol.pl
##>>	Created Time:	2014-06-26 14-12-02
##>>	Mail:	LPJ@whu.edu.cn
##>>######################################################
use warnings;
use strict;
#########################################################
# input file should be TAB seperate txt file with a single column 
# contain UCSC gene ID. By given UCSC_gene_ID column field No. and 
# use hg19 or any given reference hgXref files, this script will 
# extract geneSymbol for each UCSC_gene_ID and add a new column 
# to input file.
#########################################################
my $kgXref = "/home/whu5003data/genome_index/hg19/hg19_kgXref.txt";
# this file contain gene id transformation 
# #kgID	mRNA	spID	spDisplayID	geneSymbol	refseq	protAcc description	rfamAcc tRnaName
# kgID is unique each row in field one
use Getopt::Long;
my %opt;
GetOptions (\%opt, "input=s","field=i","output=s","help");
if(defined $opt{'help'}) {
	print<<EOF;
	Usage:	$0	-input <*>	-field <*>	-output <*>	-help
	############################
EOF
exit(0);
}
my %kgID=(); # UCSC known gene ID;
open my $kg_fh, "<", $kgXref || die "can not open kgXref file. \n";
while (<$kg_fh>) {
	chomp;
	next if /^#/;
	my @tmp = split/\t/;
	if (defined $tmp[4]) {
		$kgID{$tmp[0]} = $tmp[4];
		}
	else {
		$kgID{$tmp[0]} = $tmp[0];
		}
	}

close $kg_fh;

##########################################################
open my $input_fh, "<",$opt{"input"} || die "can not open the file. \n";
my $head_line = <$input_fh>;
chomp $head_line;
open my $output_fh, ">",$opt{"output"} || die "can not open the file. \n";
print $output_fh "#$head_line\tgeneSymbol\n";
my $field = $opt{"field"};
my $index = $field - 1;
while (<$input_fh>) {
	chomp;
	my @tmp = split/\t/;
	my $ucsc_col = $tmp[$index];
	my %gene=();	# store gene name for ucsc ID; if there are more than one UCSC ID each row;
	if ($ucsc_col =~ m/,/) {
		# one gene_id has more than one UCSC_ID;
		my @uc_id = split/,/,$ucsc_col;
		for (@uc_id) {
			my $gene_name = $kgID{$_};
			$gene{$gene_name} = 1; # omit duplicate gene name;
			}
		my @gene_name_omited = keys %gene;
		for (@gene_name_omited) {
		print $output_fh join("\t",@tmp,$_),"\n";
		}
	}
	else {
		print $output_fh join("\t",@tmp,$kgID{$ucsc_col}),"\n";
		}
	}
close $input_fh;
close $output_fh;



