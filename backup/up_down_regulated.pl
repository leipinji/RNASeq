#!/usr/bin/perl
# File name : up_down_regulated.pl
#Author: Lei Pinji
#Mail: LPJ@whu.edu.cn
###############################
use warnings;
use strict;
use Getopt::Long;

unless (@ARGV) {
	print<<EOF;
	Usage:	up_down_regulated.pl	-file <*>	-up <*>		-down <*>
	Options:	
		-file	input file
		-up	up regulated genes
		-down	down regulated genes
EOF
exit(0);
	}

my ($file,$up,$down);

GetOptions (
		'file=s'	=>\$file,
		'up=s'		=>\$up,
		'down=s'	=>\$down
		);
	
	open my $file_fh, "<", $file or die "can not open the input file. \n";
	open my $up_fh, ">", $up or die "can not open up regulated file. \n";
	open my $down_fh, ">", $down or die "can not open down regulated file. \n";

	while (<$file_fh>) {
		chomp;
		next if /^#/;
		my @tmp = split/\t/;
		if ($tmp[3] < 0) {
			print $down_fh join("\t",@tmp),"\n";
			}
		elsif ($tmp[3] > 0) {
			print $up_fh join("\t",@tmp),"\n";
			}
		}
	
	close $file_fh;
	close $up_fh;
	close $down_fh;


