#!/usr/bin/perl

use Data::Dumper;
use Configuration;
use strict;
use POSIX 'strftime';

use vars qw( $instaLag $currentTime );

BEGIN {
	*currentTime = \$Configuration::currentTime; #-- aliasing
}

#our $binLag = {

#	"min" => { "window" = 15 },
#	"hour" => { "window" = 8 },
#	"daily" => { "window" = 2 },
#};
our ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
our ($last_sec,$last_min,$last_hour,$last_mday,$last_mon,$last_year,$last_wday,$last_yday,$last_isdst);

$mon += 1;
$year += 1900;

our $current = `date -d \@$currentTime`;

unless ( -e "lastTime.txt"){
	open (WRITE ,">" , "lastTime.txt") || die $!;
}

open (READ ,"<" , "lastTime.txt") || die $!;

my $read = <READ>;

if  ( $read ){

	chomp($read);

# Time extracted from the Last time file.
	($last_sec,$last_min,$last_hour,$last_mday,$last_mon,$last_year,$last_wday,$last_yday,$last_isdst) = split (/,/,$read);

	print "All Adaptor bin Calculation Starts at $current";

	my @Adapters = `ssh -q root\@172.30.3.60 '/opt/tms/bin/cli -t "en" "internal query iterate subtree /nr/collector/instance/1/adaptor"' | awk -F/ '{print \$7}' | awk '{print \$1}' | sort -u`;
	chomp (@Adapters);

	foreach my $adap (@Adapters){

		my $binTime = `ssh -q root\@172.30.3.60 '/opt/tms/bin/cli -t "en" "internal query iterate subtree /nr/collector/instance/1/adaptor" | grep $adap |  grep -v stats|  grep bin_size ' | awk -F= '{print \$NF}' | awk '{print \$1}'`;
		chomp($binTime);

		if ( $binTime == 3600 ){

			if ( $hour > $last_hour ){

				print "$adap is a hourly bin";
				my $`ssh -q root\@172.30.3.60 hadoop  dfs -ls /data/collector/output/lte/2014/01/01/ 2>/dev/null` ;


			}

		}

	}


#print WRITE "$sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst";	

}
else {

	print "Script running for the 1st time and hence did not find any date to compare with\n";
	print WRITE "$sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst";	
	exit;
}

