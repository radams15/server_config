#!/usr/bin/perl

use CGI ':standard';

use lib '.';
use shared ();

print &http_header;

sub titlepage {
    (
        div({
                class => 'title centre_page'
            },
            h1({ class => 'centre' }, 'Rhys Adams'),
            txt(
"I'm Rhys - I study BSc Cyber Security at the University of Warwick."
            ),
            txt("I enjoy reverse engineering and low-level programming."),
            txt(
                "My GPG key is available",
                a({ href => '/radams.pgp' }, 'here'),
                '(',
                code('A53C 328F 5CA7 D1EA 4E16  0A58 C783 AD16 F241 1208'),
                ')'
            ),
        ),
    );
}

sub page_body {
    &page(
        content => div(&titlepage),
    );
}

print html (CGI::head(&page_head('Rhys Adams')), CGI::body(&page_body),);
