#!/usr/bin/perl
use warnings;
use strict;
############################
# this script sum all isoform FPKM value which comes from the same GeneSymbol
#
############################

my ($input, $output) = @ARGV;
unless (@ARGV == 2) {
	print<<EOF;
	####################################
	Usage:	$0 <input>	<output>
	Options:
		<input>	UcscToGeneSymbol.pl output file
		<output>	output
	###################################
EOF
exit(0);
}

open my $input_fh, "<", $input or die;
open my $output_fh, ">", $output or die;

my %geneSymbol = ();
my @header = ();
my $labels = <$input_fh>;
@header = split/\t/, $labels;
my $index = @header-2;

while (<$input_fh>) {
	chomp;
	my @tmp = split/\t/;

#$$file frmat$$
# gene_id	ucsc_id ... geneSymbol	
	my $geneName = $tmp[-1];
	for (2..$index) {	# samples
		$geneSymbol{$geneName}{$header[$_]} += $tmp[$_];
		}
	}

my @sorted_keys = sort {$a cmp $b} keys %geneSymbol ;
print $output_fh join("\t","#geneSymbol",@header[2..$index]),"\n";
for my $gene(@sorted_keys) {
	my @samples = ();
	for (2..$index) {
		push @samples, $geneSymbol{$gene}{$header[$_]};
		}
	print $output_fh join("\t",$gene,@samples),"\n";
	}

close $input_fh;
close $output_fh;


 


		
	
