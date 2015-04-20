#!/usr/bin/perl

use Data::Dumper;
use Configuration;
use strict;
use POSIX 'strftime';

use vars qw( $hadoopdfs $currentTime );

BEGIN {
        *hadoopdfs = \$Configuration::hadoopdfs; #-- aliasing
        *currentTime = \$Configuration::currentTime; #-- aliasing
}


our $current = `date -d \@$currentTime`;
print "Hadoop monitoring at $current\n";

foreach my $nodes (keys %{$hadoopdfs->{'monitor'}}){

	my $t = `ssh -q root\@$hadoopdfs->{'monitor'}->{$nodes}->{ip} $hadoopdfs->{'monitor'}->{$nodes}->{cmd}`;

	$t =~ s/^DFS Used%: (.*?)\%$/$1/g;
	chomp($t);
	print "DFS Used for $nodes is $t\n ";
	if ($t > $hadoopdfs->{'monitor'}->{$nodes}->{'limit'}){

		&Configuration::send_mail("production.monitoring\@guavus.com",$hadoopdfs->{email_to},$hadoopdfs->{email_cc},"Hadoop DFS used","App Name : $nodes \n IP : $hadoopdfs->{'monitor'}->{$nodes}->{ip} \n DFS used : $t");

		print "Mail Sent $nodes DFS used is $t\n";

	}


}


