#!/usr/bin/perl

use Data::Dumper;
use Configuration;
use strict;
use POSIX 'strftime';

use vars qw( $hadoop_mising_corpt $currentTime );

BEGIN {
        *hadoop_mising_corpt = \$Configuration::hadoop_mising_corpt; #-- aliasing
        *currentTime = \$Configuration::currentTime; #-- aliasing
}


our $current = `date -d \@$currentTime`;
print "Hadoop monitoring at $current\n";

foreach my $nodes (keys %{$hadoop_mising_corpt->{'monitor'}}){

	
	my $cmd = $hadoop_mising_corpt->{'monitor'}->{$nodes}->{cmd} . " | tail -1";

	my $t = `ssh -q root\@$hadoop_mising_corpt->{'monitor'}->{$nodes}->{ip} $cmd`;
	chomp ($t);

	print "$t for $nodes\n";

	if ($t !~ /healthy/ig  ){

		$cmd = $hadoop_mising_corpt->{'monitor'}->{$nodes}->{cmd} . " | tail -19";

		my $v = `ssh -q root\@$hadoop_mising_corpt->{'monitor'}->{$nodes}->{ip} $cmd`;
		&Configuration::send_mail("production.monitoring\@guavus.com",$hadoop_mising_corpt->{email_to},$hadoop_mising_corpt->{email_cc},"Filesystem is $t on $hadoop_mising_corpt->{'monitor'}->{$nodes}->{ip}","$v");

		print "Mail Sent Filesystem is not healthy  for  $nodes \n";

	}


}


