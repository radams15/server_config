#!/usr/bin/perl

use CGI ':standard';

use lib '.';
use shared ();

print CGI::header("text/html;charset=UTF-8");

sub titlepage {
	(
		div({
				class => 'title centre'
			},
			h1({ class=>'centre' }, 'Rhys Adams'),
			txt("I'm Rhys - I study BSc Cyber Security at the University of Warwick."),
			txt("I enjoy reverse engineering and low-level programming."),
			txt("My GPG key is available", a({href=>'/radams.pgp'}, 'here'), '(', code('A53C 328F 5CA7 D1EA 4E16  0A58 C783 AD16 F241 1208'), ')'),
		),
	);
}

sub page_body {
	(
		&navbar,
		&titlepage,
		&footer,
	);
}
	
print html (
	CGI::head(&page_head('Rhys Adams')),
	CGI::body(&page_body),
);
