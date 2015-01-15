#!/usr/bin/perl
##>>######################################################
##>> 	Author Name:	Lei Pinji
##>>	Title:	differential_expression.pl
##>>	Created Time:	2014-06-26 15-37-19
##>>	Mail:	LPJ@whu.edu.cn
##>>######################################################
use warnings;
use strict;
### use this script to figure out DE genes under current work directory
### since this script only do two samples DE test, if both samples'
### FPKM value less than 1, this gene will be ignored
##########################################################
use Cwd;
######### sub routine ##########
sub DEG;
use Getopt::Long;
my $fold;
GetOptions (
		"fold=i"	=> \$fold
		);
unless (defined $fold) {
	print<<EOF;
	######################################
	Usage $0	-fold <int>	
	this script will calculate DEGs under sub-directory
	sub-directory contain <*.fpkm> file
	#####################################
EOF
exit(0);
}
my $current_work_dir = cwd();
opendir my $work_dir,$current_work_dir || die "can not open current directory. \n";
my $file;	# file or directory under current work directory;
while ($file = readdir $work_dir) {
	next if $file eq "." or $file eq "..";
	if (-d $file) {
		# file is a directory;
		# change to sub-directory;
		chdir $file;
		my $tmp_dir = cwd();
		print "current work directory $tmp_dir. \n";
		# this message will print to stdout
		my ($fpkm_file) = <*fpkm>;
		print "my file is $fpkm_file\n";
		DEG($fpkm_file);
		chdir $current_work_dir;
		}
	}
closedir $work_dir;

########################################################

sub DEG {
	my $file = $_[0];
	open my $fd, "<",$file || die "can not open the file $file. \n";
	open my $output_fh, ">","./differential_expression_genes.txt" || die "can not touch output file. \n";
	print $output_fh join("\t","#geneSymbol","sample1","sample2","foldChange[log(2)]"),"\n";
	# file format 
	###########
	#geneSymbol	sample1	sample2	
	while (<$fd>) {
		chomp;
		next if /^#/;
		my @tmp = split/\t/;
		next if $tmp[1] < 1 and $tmp[2] <1;
		# both sample1 and sample2 FPKM value less than 1 will be ignored
		my $sample1 = $tmp[1]+1;
		my $sample2 = $tmp[2]+1;
		############ gene expression value less than 1 will be routedly set to 1 ############

		my $ratio = log($sample2/$sample1)/log(2);
		my $cutoff = log($fold)/log(2);
		if ($ratio >= $cutoff || $ratio <= -$cutoff) {
			print $output_fh join ("\t",$tmp[0],$sample1,$sample2,$ratio),"\n";
			}
		}
		close $fd;
		close $output_fh;
	}


	
