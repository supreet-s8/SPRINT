#!/usr/bin/perl

use Data::Dumper;
use strict;
use POSIX 'strftime';


open (DATA,"<","signature.txt") || die $!;
my @arr = <DATA>;
chomp (@arr);

my $signature={};

foreach (@arr){

	my @a = split(",",$_);

	$signature->{$a[0]}->{firstname} = $a[2];
	$signature->{$a[0]}->{lastname} = $a[1];

}

my $no_of_days = "";

if ($ARGV[0]){
	$no_of_days = $ARGV[0];
}else{
	$no_of_days = 8;
}

#print "Number of days to be iterated : $no_of_days\n\n";

our $current_epoch = time();
chomp ($current_epoch);

unless (-d "/data/instances/spw/1/bin") {
	print "\"/data/instances/spw/1/bin\" directory does not exists on the server";
	exit;
}

my $data_hash = {};

foreach (my $i = 1 ; $i < $no_of_days ; $i++){

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime ( $current_epoch - ( $i * 86400 ) );
	$year += 1900;
	$mon += 1;

	$mon =~ s/^(.*?)$/length($1) == 1 ? "0".$1:$1/ge;
	$mday =~ s/^(.*?)$/length($1) == 1 ? "0".$1:$1/ge;
	$hour =~ s/^(.*?)$/length($1) == 1 ? "0".$1:$1/ge;

	open (DATA,"<","/data/instances/spw/1/bin/nae.$year-$mon-$mday.log");
#	open (DATA,"<","/data/instances/spw/1/bin/nae.log");

#	print "$i. /data/instances/spw/1/bin/nae.$year-$mon-$mday.log\n";

	while (<DATA>){

		my ($user,$login,$signout,$application,$value)="";
		chomp ;
		next if ($_ =~ m/^$/);

		if ($_ =~ m/(.*?)\..*?\[.*?\].*?\[.*?\] \[(.*?)\] --.*\[.*?HomeModule.swf\]$/ig){

			$user = "$2";
			$login = $1;
			$data_hash->{$user}->{login} = $login if ($1);

		}

		if ($_ =~ m/.*?\[.*?\] INFO .*? - \[.*?\] \[(.*?)\] --.*?\[.*\/(.*?)_.*?\.swf.*\].*$/ig){

			$user = $1;
			$application = $2;
			push (@{$data_hash->{$user}->{application}} , $application )if ($2);

		}
		if ($_ =~ m/(.*?)\..*?\[.*?\].*?\[.*?\] \[(.*?)\] --.*?->signout.*$/ig){

			$signout = $1;
			$user = $2;
			$data_hash->{$user}->{signout} = $signout if ($1);

		}	
#$data_hash->{$user}->{year} = 2014;
#$data_hash->{$user}->{month} = 05;
#$data_hash->{$user}->{mday} = 04;
		$data_hash->{$user}->{year} = $year;
		$data_hash->{$user}->{month} = $mon;
		$data_hash->{$user}->{mday} = $mday;
	}

}

close DATA;
print FILE "S.No., Login Id, Last Name, First Name, Login Day, Login Time, Logout Day, Logout Time, Reason for Logout, Applications Accessed During Login Session\n";
my $k =0;
foreach my $u ( keys %{$data_hash} ){

	next if ($u =~ m/^null/g);
	$u =~ m/(.*?)-.*$/; 
	my $username = $1;
	my $signout_reason = "";

	my $text = "";
	if ($u){

		$k++;
		$text .= "$k" ;

		$text .= ", $username";

		if ($signature->{$username}->{lastname}){
			$text .= ", $signature->{$username}->{lastname}";	
		}else {
			$text .= ", ";	
		}

		if ($signature->{$username}->{firstname}){
			$text .= ", $signature->{$username}->{firstname}";	
		}else {
			$text .= ", ";	
		}

		if ($data_hash->{$u}->{login}){

			$text .= ", $data_hash->{$u}->{month}/$data_hash->{$u}->{mday}/$data_hash->{$u}->{year}, $data_hash->{$u}->{login}"; 
		}else{
			next;
		}			

		if ($data_hash->{$u}->{signout}){

			$text .= ", $data_hash->{$u}->{month}/$data_hash->{$u}->{mday}/$data_hash->{$u}->{year}, $data_hash->{$u}->{signout}"; 
			$signout_reason = "SignOut";
		}else{
			$signout_reason = "TimeOut";
			$text .= ", , ";
		}			

		if ($signout_reason){
			$text .= ", $signout_reason";
		}else{
			$text .= ", ";	
		}

		if ($data_hash->{$u}->{application} && scalar (@{$data_hash->{$u}->{application}} > 0)){
			$text .= ", ".join(':', @{$data_hash->{$u}->{application}});
		}else{
			$text .= ", ";	
		}

		print $text ."\n";

	}
}
