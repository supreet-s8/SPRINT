#!/usr/bin/perl

use Data::Dumper;
use Configuration;
use strict;
use POSIX 'strftime';

use vars qw( $collectorLag $currentTime );

BEGIN {
	*collectorLag = \$Configuration::collectorLag; #-- aliasing
		*currentTime = \$Configuration::currentTime; #-- aliasing
}

our $current = `date -d \@$currentTime`;
print "Collector Lag at $current\n";

foreach my $ip (keys %{$collectorLag->{'monitor'}}) {


	foreach (@{$collectorLag->{'monitor'}->{$ip}->{'adaptors'}}){

		my $lag = `ssh -q root\@$ip "/opt/tms/bin/cli -t 'en' 'collector stats instance-id 1 adaptor-stats $_ last-freezed-bin'"`;
		my $l = `date -d \@$lag`;

		if (!$lag){
			print "Last freezed bin not found at $ip for adaptor $_ \n";
			next;
		}else{

			my $date = strftime '%m:%d:%H:%M:%S', localtime $currentTime - $lag;
			my $day = strftime '%H', localtime $currentTime - $lag; 
	
			print "Current Collector lag at $ip\n";

			print "TOTAL Lag $_ = $day Hours \n";

			if ($day > $collectorLag->{$ip}->{'limit'}){
				&Configuration::send_mail("production.monitoring\@guavus.com",$collectorLag->{email_to},$collectorLag->{email_cc},"Collector Lag on $ip","App Name : $collectorLag->{'monitor'}->{$ip}->{'app_name'} \n IP : $ip \n Current Time : $current \n Bin Time : $l \n Lag : $day");
				print "Mail Sent because lag limit is exceded for $_ on $ip\n\n";
			}else {
				print "Lag limit for adaptor $_ is $day Days on $ip\n\n";
			}

		}
	}
}

