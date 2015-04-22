#!/usr/bin/perl;
$file=$ARGV[0];

open(IN,$file) || die "not able to open file $! \n";
open(OUT,">","/data/offshore_support/hadoop-log-parser/out.txt") || die "not able to open file $! \n";

@arr=<IN>;
$flagp=0;
foreach $i (0..$#arr){

chomp($arr[$i]);

if(($arr[$i] =~ /Bytes Skipped/) || ($arr[$i] =~ /Files Skipped/)){
	$flagP=1;
}

if(($arr[$i] =~ /WIMAX/) || ($arr[$i] =~ /VOICE/) || ($arr[$i] =~ /IPDR/) || ($arr[$i] =~ /LTE/)){

	$flagP=0;
}

	if($flagP == 1){
	print OUT "$arr[$i]\n";
	}
}

close(IN);
close(OUT);
