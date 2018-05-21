#!/usr/bin/perl
##>>######################################################
##>> 	Author Name:	Lei Pinji
##>>	Title:	RNA-Seq.pl
##>>	Created Time:	2014-07-10 13-22-08
##>>	Mail:	LPJ@whu.edu.cn
##>>######################################################
use warnings;
use strict;
####################
# run tophat to map PE reads to reference genome
# run cufflinks under current work directory 
# each sub-directory contain a single sample
###################
# tophat map to genome
#         ||
#         VV
# cufflinks assemble mapped reads
#         ||
#         VV
# cuffmerge merges assembled gtf
#         ||
#         VV
# cuffdiff figure out differential expression genes
###################
use Cwd;
my $current_work_dir = cwd();	# get current work directory;

################### run tophat under sub-directory ######################
my $tophat_index = "/home/whu5003data/genome_index/hg19/bowtie2_index/hg19.bowtie2";
my $ref_gtf = "/home/whu5003data/genome_index/hg19/hg19_knownGene.gtf";
my $tophat_cmd = "tophat -o tophat_out -r 200 --library-type fr-unstranded -p 5 -G $ref_gtf $tophat_index";
# basic tophat command;


################### run cufflinks command ###################
my $mask_file = "/home/whu5003data/genome_index/hg19/hg19_rRNA_tRNA.gtf";
my $cufflinks_cmd = "cufflinks -o cufflinks_out -p 5 --total-hits-norm -v -G $ref_gtf -M $mask_file";
# basic cufflinks command;


################### run cuffmerge ###########################
my $genome_fa = "/home/whu5003data/genome_index/hg19/hg19.fa";	# genome fasta file;



################## tophat options ###########################
# -o/--output-dir
# -r/--mate-innner-dist
# -p 
# -G 
#############################################################
use Getopt::Long;
my $labels;
my $help;
GetOptions (
	"labels|l=s" => \$labels,
	"help|h"     => \$help
	);
	# labels should be comma seperated characters
if (defined $help) {
	usage ();
	exit(0);
}

my @labels = split/,/,$labels;


my @transcripts = ();
for (@labels) {
	my $dir_name = $_; # sample name is directory name;
	# this name will be used as label
	chdir $dir_name;
	my ($r1) = <*R1*fastq.gz>;
	my ($r2) = <*R2*fastq.gz>;
	system ("$tophat_cmd $r1 $r2 > tophat_log 2>&1");
	# output file under sample directory tophat_out directory;
	chdir "tophat_out";
	# work under tophat_out directory;
	system ("$cufflinks_cmd accepted_hits.bam > cufflinks_log 2>&1");
	# cufflinks output directory is cufflinks_out;
	my $tmp_dir = cwd();
	my $transcript_gtf = "$tmp_dir/cufflinks_out/transcripts.gtf";
	# assembles transcripts gtf file;
	push @transcripts, $transcript_gtf;
	chdir $current_work_dir;
	}

open my $merged_fh, ">", "assembled.txt" || die "can not open assembled file.\n";
for (@transcripts) {
	print $merged_fh "$_\n";
	}
close $merged_fh;

system ("cuffmerge -p 5 -o cuffmerge_out -g $ref_gtf -s $genome_fa assembled.txt");
# merged.gtf file under cuffmerge_out directory;


################# cuffdiff options###########
# -o output directory			    
# -L labels				    
# -p threads
# --FDR default 0.05
# -M/--mask-file
# --total-hits-norm
# -v/--verbose
#############################################

my @samples = (); # samples accepted BAM file
for (@labels) {
	my $file = "$current_work_dir/$_/tophat_out/accepted_hits.bam";
	push @samples,$file;
	}
my $sample_file = join(" ",@samples);

system ("cuffdiff -o cuffdiff_out -L $labels -p 5 -M $mask_file --total-hits-norm -v cuffmerge_out/merged.gtf $sample_file");



sub usage {
	print <<EOF;
$0 -labels <labels> 
################
labels should be comma seperated characters which means sample sub-directory
EOF
}
