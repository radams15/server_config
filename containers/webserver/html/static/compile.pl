#!/usr/bin/env perl

for(<*.scss>) {
	next if /_.*\.scss/;

	print "Compile: $_\n";
	(my $new = $_) =~ s/\.scss$/.css/g;

	system("sass $_  $new");
}
