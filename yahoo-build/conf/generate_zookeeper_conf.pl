#!/usr/local/bin/perl -w

# Output a zookeeper config file based on settings for each config item.  
# Does not do any type checking on the variables. 

use strict;

use vars qw/ @ARGV %ENV /;

my @variables = qw/
	tickTime
	initLimit
        forceSync
        globalOutstandingLimit
        syncEnabled
	syncLimit
	snapCount
	dataDir
	dataLogDir
	clientPort
        clientPortAddress
        cnxTimeout
        maxSessionTimeout
        minSessionTimeout
	maxClientCnxns
        leaderServes
	electionAlg
        preAllocSize
        quorumListenOnAllIPs
        skipAC
        traceFile
/;

# Redefine params with dot(s) in their name so yinst can set 'em
# (who would want to type in these long a$$ strings, anyway?)
my %redefs = (
    fsyncWarningWait    => 'fsync.warningthresholdms',
    readOnly            => 'readonlymode.enabled',
    snapRetainCount     => 'autopurge.snapRetainCount',
    purgeInterval       => 'autopurge.purgeInterval',
    superDigest         => 'zookeeper.DigestAuthenticationProvider.superDigest',
    juteMaxBuffer       => 'jute.maxbuffer',
);

# Set the default values for the config variables if they aren't explictly set
my %defaults = (
	'tickTime' => 2000,
	'initLimit' => 20,
	'syncLimit' => 15,
	'snapCount' => 100000,
	'dataDir' => "$ENV{ROOT}/var/zookeeper",
	'clientPort' => 2181,
	'quorumPort' => 2182,
	'electionPort' => 2183,
);


foreach my $default( keys %defaults ) {
	if( !exists( $ENV{$default} ) or $ENV{$default} eq '' ) {
		$ENV{$default} = $defaults{$default};
	}
}

# Print out all the variables
foreach my $variable( @variables ) {
    next if not defined $ENV{$variable};
	print "$variable=$ENV{$variable}\n";
}

if( defined $ENV{'kerberos'} ) {
	if( $ENV{'kerberos'} eq 'true' ) {
		print "authProvider.1 = org.apache.zookeeper.server.auth.SASLAuthenticationProvider\n";
		print "kerberos.removeHostFromPrincipal = true\n"; 
		print "kerberos.removeRealmFromPrincipal = true\n";
	}
}

if( defined $ENV{'quorum'} ) {
    # allow both whitespace and comma separated values
	my @quorum_hosts = split( /\s+|,/, $ENV{'quorum'} );
	
	my $counter = 1;
	foreach my $host( @quorum_hosts ) {
        # if quorum contains : then user is overriding quorumPort/electionPort
        if ($host =~ m/:/) {
            print "server.$counter=$host\n";
        } else {
            print "server.$counter=$host:$ENV{'quorumPort'}:$ENV{'electionPort'}\n";
        }
		$counter++;
	}
}

if (defined $ENV{groups}) {
        my @groups = split /(?:\s*,\s*|\s+)/, $ENV{groups};
        for my $id (1 .. @groups) {
                print "group.$id=" . $groups[$id-1], "\n";
        }
}

if (defined $ENV{weights}) {
        my @weights = split /(?:\s*,\s*|\s+)/, $ENV{weights};
        for my $w (@weights) {
            print "weight.$w\n";
        }
}

foreach my $setting (keys %redefs) {
        my $value = $ENV{$setting};
        if (defined $value) {
                print "$redefs{$setting}=$value\n";
        }
}
