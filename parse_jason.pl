#! /usr/bin/perl
use JSON;
%hash=();

if (@ARGV){
	$SOURCE=$ARGV[0];
}
else{
	$SOURCE="/data/guavus/carereflex_v2.0/transform_passed/";
}

open (IN,"/root/data_source/config.txt") || die "$!";

while ($line=<IN>){
	
		chomp ($line);
		($f,$s)=split(':',$line);
		$hash{'file'} = $f;
		$hash{'region'} = $s;
		check($hash{'file'},$hash{'region'});
}

#check($hash{'file'},$hash{'region'});

sub check {

	($fil,$reg)=@_;
	@arr=split(',',$reg);
 	%h=();
	$srce_file=`ls -tr $SOURCE|grep $fil|tail -1`;	
	$d=`ls -tr $SOURCE|grep $fil|tail -1 | cut -d'.' -f2 | sed 's/--/ /g' | cut -d' ' -f1`;	
	$t=`ls -tr $SOURCE|grep $fil|tail -1 | cut -d'.' -f2 | sed 's/--/ /g' | cut -d' ' -f2 | sed 's/-/:/g' | cut -d: -f1-3`;
	chomp ($d);
	chomp ($t);
	$file_epoc=`date -d "$d $t" +%s`;
	chomp ($tmp,$file_epoc);
	$curr_time = time;
	chomp ($ct);
	$time_limit=$curr_time-900;
	chomp($time_limit);
		if (($file_epoc <= $curr_time) && ($file_epoc > $time_limit)){
			
			open (INPUT,"$SOURCE/$srce_file") || die "$!\n";
			@array=<INPUT>;	
			foreach $k (@arr){
				$content=grep(/$k/,@array);
				#print "$k --> $content\n";
				$h{$k}=$content;			
			}
		$json_text = to_json(\%h);
		print "$fil $json_text\n";
		}
		
}
close(IN);
close(INPUT);
