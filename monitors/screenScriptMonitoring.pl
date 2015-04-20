#!/usr/bin/perl

use Data::Dumper;
use Configuration;
use strict;
use POSIX 'strftime';

use vars qw( $screenScriptMonitoring $currentTime );

BEGIN {
        *screenScriptMonitoring = \$Configuration::screenScriptMonitoring; #-- aliasing
        *currentTime = \$Configuration::currentTime; #-- aliasing
}

our $current = `date -d \@$currentTime`;
print "Sreen and Script Monitoring  at $current\n";


foreach my $ip (keys %{$screenScriptMonitoring->{'monitor'}}){

	foreach (@{$screenScriptMonitoring->{'monitor'}->{$ip}}){

		my $t = `ssh -q root\@$ip ps -ef`;

		if ($t !~ m/$_/osg){
			&Configuration::send_mail("production.monitoring\@guavus.com",$screenScriptMonitoring->{email_to},$screenScriptMonitoring->{email_cc},"$_ is not running on $ip","App Name : $screenScriptMonitoring->{app_name} \n JOB : $_ \n IP : $ip \n Current time : $current ");
			print "Mail Sent because $_ is not running on $ip\n\n";
		}else {
			print "$_ is running on $ip\n\n";
		}
	}
} 


