#!/usr/bin/perl

use CGI ':standard';

use lib '.';
use menu ();

print CGI::header;

sub titlepage {
	(
		div({
				class => 'title centre'
			},
			h1({ class=>'centre' }, 'Rhys Adams'),
			txt("I'm Rhys - I study BsC Cyber Security at the University of Warwick."),
			txt("I enjoy reverse engineering and low-level programming."),
		),
	);
}

sub page_body {
	(
		&navbar,
		&titlepage,
	);
}
	
print html (
	CGI::head(&page_head('Rhys Adams')),
	CGI::body(&page_body),
);
