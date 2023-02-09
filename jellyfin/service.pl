#!/usr/bin/perl

use warnings;
use strict;

my $file = $0;

my $COMPOSE = 'podman-compose';

sub usage {
	print "Usage: $file [start|stop|restart|status]\n";
}

my $op = shift @ARGV or die &usage;
chomp;

if($op eq 'start'){
	system("$COMPOSE pull");
	system("$COMPOSE up -d");
} elsif ($op eq 'stop'){
	system("$COMPOSE down");
} elsif ($op eq 'status'){
	system("$COMPOSE ps");
} elsif ($op eq 'restart'){
	system("$COMPOSE down");
	system("$COMPOSE up -d");
} elsif ($op eq 'pull'){
	system("$COMPOSE pull");
}
