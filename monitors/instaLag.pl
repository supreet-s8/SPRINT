#!/usr/bin/perl

use Data::Dumper;
use Configuration;
use strict;
use POSIX 'strftime';

use vars qw( $instaLag $currentTime );

BEGIN {
	*instaLag = \$Configuration::instaLag; #-- aliasing
		*currentTime = \$Configuration::currentTime; #-- aliasing
}


our $current = `date -d \@$currentTime`;
print "iNSTA Lag at $current\n";

foreach my $lagfor (keys %{$instaLag->{'monitor'}}){

	my $binTime = `ssh -q root\@$instaLag->{'monitor'}->{$lagfor}->{'ip'} "/usr/local/Calpont/mysql/bin/mysql --defaults-file=/usr/local/Calpont/mysql/my.cnf -u root $instaLag->{'monitor'}->{$lagfor}->{'db'} -e \\"$instaLag->{'monitor'}->{$lagfor}->{'query'}\\"" | tail -1`;

	my $bin = `date -d \@$binTime`;
	
	if (!$binTime){
		print "Bintime doesnot exists for $lagfor on $instaLag->{'monitor'}->{$lagfor}->{'ip'} \n";
		next;
	}else{
		my $date = strftime '%m:%d:%H:%M:%S', localtime $currentTime - $binTime;

		print "Component $lagfor on $instaLag->{'monitor'}->{$lagfor}->{'ip'} lag in H:M:S $date\n";

		my $hr = strftime '%H', localtime $currentTime - $binTime; 
		my $day = strftime '%d', localtime $currentTime - $binTime; 

		if ( $day > $instaLag->{'monitor'}->{$lagfor}->{'daylimit'}   && $hr > $instaLag->{'monitor'}->{$lagfor}->{'hourlimit'}  ){

			&Configuration::send_mail("production.monitoring\@guavus.com",$instaLag->{email_to},$instaLag->{email_cc},"Insta Lag on  $instaLag->{'monitor'}->{$lagfor}->{'ip'}","App Name : $instaLag->{'monitor'}->{$lagfor}->{'app_name'} \n IP : $instaLag->{'monitor'}->{$lagfor}->{'ip'} \n Current Time : $current \n Bin Time : $bin \n Lag $date");
			print "Mail Sent because bin time limit is exceded for $lagfor on $instaLag->{'monitor'}->{$lagfor}->{'ip'}\n\n";
		}
		else {
			print "Lag for $lagfor is $day on $instaLag->{'monitor'}->{$lagfor}->{'ip'}\n\n";
		}
	}
}
