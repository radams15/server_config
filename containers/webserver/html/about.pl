#!/usr/bin/perl

use CGI ':standard';

use lib '.';
use menu ();

print CGI::header;

sub page {
	(
		div({
				class => 'title centre'
			},
			
			h1({ class=>'centre' }, 'About'),
		),
		
		div({
				class => 'about centre_page'
			},
			
			h2({ class=>'centre' }, 'Me'),
			
			txt("I'm currently studying BsC Cyber Security at the University of Warwick."),
			txt("My favourite areas include binary exploitation and reverse engineering, as well as network design and implementation."),
			txt("Of course, I also thouroughly enjoy programming with a variety of languages and tools:"),
			ul(
				# Languages
				li('Perl'),
				ul (
					li('Mojolicious'),
					li('CGI.pm'),
				),
				li('Python'),
				li('C++'),
				ul (
					li('WxWidgets'),
					li('Qt'),
				),
				li('C'),
				# Tools
				li('Docker/Podman'),
				li('Linux'),
			),
			txt("Some of my other interests include vintage computers, electronics, and music on a variety of formats."),
			
			
			h2({ class=>'centre' }, 'The Website'),
			
			txt("These pages are written from scratch using Perl's CGI.pm which allows a very light, reasonably powerful backend without the need to touch any PHP."),
			txt("This site is hosted on my home 'server' - a 2012 HP Elitebook 8570p running RHEL 8. I use Podman to run various containers, including:"),
			ul(
				li('An NGINX reverse proxy'),
				li('Cloudflare tunnels to allow outside access to this site'),
				li('Apache httpd with mod_cgi'),
			),
		),
	);
}

sub page_body {
	(
		&navbar,
		&page,
	);
}
	
print html (
	CGI::head(&page_head('Rhys Adams - About')),
	CGI::body(&page_body),
);
