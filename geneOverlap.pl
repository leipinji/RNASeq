#!/usr/bin/perl
##>>######################################################
##>> 	Author Name:	Lei Pinji
##>>	Title:	geneOverlap.pl
##>>	Created Time:	2014-07-11 10-22-20
##>>	Mail:	LPJ@whu.edu.cn
##>>######################################################
use warnings;
use strict;
use Getopt::Long;

##########################################################
# this script will figure out overlap genes between to TAB separated file
# if not given field number then use the whole line as a unit,
# else if give a single field number, then use this field as a index to find out 
# overlap gene list and return uniq genes in each file.
# if give two field number, then each file use a uniq field as index
##########################################################
use Pod::Usage;
my $message =<<EOF;
Usage:	geneOverlap.pl	[options]
Options:	
		-a(string)	first tab delimited file
		-b(string)	second tab delimited file
		-o(string)	output overlap row
		-la(int)	index field number in first file, multiple field should be comma seperated
		-lb(int)	index field number in second file, multiple field should be comma seperated
		-l|-label(int)	index field in both file
		-ua(string)	first file unique row
		-ub(string)	second file unique row
####################################################################
EOF
unless (@ARGV) {
	pod2usage ($message);	
	exit(0);
	}
my %opt=();

GetOptions (\%opt,
		"a=s",	# first tab delimited file;
		"b=s",	# second tab delimited file;
		"la=s",	# index field number in first file;
		"lb=s",	# index field number in second file;
		"label|l=s",	# index field number in both file;
		"ua=s",	# first file unique row;
		"ub=s",	# second file unique row;
		"output|o=s",	# overlap row;
		);
my ($first,$second,$output,$la,$lb,$label,$ua,$ub);
if (defined $opt{'a'}) {
	$first = $opt{'a'};
	}
if (defined $opt{'b'}) {
	$second = $opt{'b'};
	}
if (defined $opt{'la'}) {
	$la = $opt{'la'};
	}
if (defined $opt{'lb'}) {
	$lb = $opt{'lb'};
	}
if (defined $opt{'label'}) {
	$label = $opt{'label'};
	}
if (defined $opt{'output'}) {
	$output = $opt{'output'};
	}
if (defined $opt{'ua'}) {
	$ua = $opt{'ua'};
	}
if (defined $opt{'ub'}) {
	$ub = $opt{'ub'};
	}
# if not define index field number then use the whole row as index 
my %row = ();
open my $first_fh, "<", $first or die "can not open first tab delimited file.\n";

while ( <$first_fh> ) {
	chomp;
	next if /^#/;
	unless ((defined $la) or (defined $label)) {
		#use whole row as index
		$row{$_} = $_;
		}


	elsif ((defined $la) and (defined $lb)) {
		my @tmp = split/\t/;
		unless ($la =~ /,/) {
			# one field as index
			my $index = $tmp[$la-1];
			$row{$index} = $_;
			}
		else {	# multiple field be given
			my @field_number = split/,/,$la;
			my @index = ();
			for (@field_number) {
				push @index, $tmp[$_-1];
				}
			my $index = join(",",@index);
			$row{$index} = $_;
			}
		}


	elsif (defined $label) {
		my @tmp = split/\t/;
		unless ($label =~ /,/) {
			# one field as index
			my $index = $tmp[$label-1];
			$row{$index} = $_;
			}
		else {
			my @field_number = split/,/,$label;
			my @index = ();
			for (@field_number) {
				push @index, $tmp[$_-1];
				}
			my $index = join(",",@index);
			$row{$index} = $_;
			}
		}
	}


open my $second_fh, "<", $second or die "can not open second tab delimited file.\n";

open my $output_fh, ">", $output or die "can not open output file.\n";
open my $ua_fh, ">", $ua or die "can not open unique first row file.\n";
open my $ub_fh, ">", $ub or die "can not open unique second row file.\n";

my %overlap_index = ();
while (<$second_fh>) {
	chomp;
	next if /^#/;
	my @tmp = split/\t/;

	unless ( (defined $lb) or (defined $label) ) {
		if (exists $row{$_}) {
			$overlap_index{$_} = 1;
			print $output_fh $_,"\n";
			}
		else {
			print $ub_fh $_,"\n";
			}
		}


	elsif ( defined $lb) {
		unless ($lb =~ /,/) {
			my $index = $tmp[$lb-1];
			if (exists $row{$index}) {
				$overlap_index{$index} = 1;
				print $output_fh $_,"\n";
				}
			else {
				print $ub_fh $_,"\n";
				}
			}

		else {
			my @field_number = split/,/,$lb;
			my @index = ();
			for (@field_number) {
				push @index,$tmp[$_-1];
				}
			my $index = join(",",@index);
			if (exists $row{$index}) {
				$overlap_index{$index} = 1;
				print $output_fh $_,"\n";
				}
			else {
				print $ub_fh $_,"\n";
				}
			}
		}


	elsif (defined $label) {
		unless ($label =~ /,/) {
			my $index = $tmp[$label-1];
			if (exists $row{$index}) {
				$overlap_index{$index} = 1;
				print $output_fh $_,"\n";
				}
			else {
				print $ub_fh $_,"\n";
				}
			}

		else {
			my @field_number = split/,/,$label;
			my @index = ();
			for (@field_number) {
				push @index, $tmp[$_-1];
				}
			my $index = join(",",@index);
			if (exists $row{$index}) {
				$overlap_index{$index} = 1;
				print $output_fh $_,"\n";
				}
			else {
				print $ub_fh $_,"\n";
				}
			}
		}
	}

#####################################################
for (keys %row) {
	unless (exists $overlap_index{$_}) {
		print $ua_fh $row{$_},"\n";
		}
	}
close $first_fh;
close $second_fh;
close $output_fh;
close $ua_fh;
close $ub_fh;

			
				
	

