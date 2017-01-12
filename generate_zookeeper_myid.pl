#!/usr/local/bin/perl

# Output a zookeeper myid file based on where the current host's name
# falls in the list of quorum servers

use strict;

use vars qw/ @ARGV %ENV /;

if( defined $ENV{'quorum'} ) {
    # use non-capturing groups
	my @quorum_hosts = split( /(?::[0-9]+)*(?:\s+|,|$)/, $ENV{'quorum'} );
	
	my $counter = 1;
	my $hostname = `hostname`;
	chop $hostname;
	
	foreach my $host( @quorum_hosts ) {
		if( $hostname eq $host ) {
			print $counter;
			last;
		}
		$counter++;
	}
}
