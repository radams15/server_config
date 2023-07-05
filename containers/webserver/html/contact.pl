#!/usr/bin/perl

use CGI ':standard';

use lib '.';
use shared ();

print &http_header;

sub li_a {
    my ($name, $url) = @_;

    li(a({ href => $url }, $name,));
}

sub content {
    (
        div({
                class => 'title centre'
            },

            h1({ class => 'centre' }, 'Contact'),
        ),

        div({
                class => 'about centre_page'
            },

            txt('Email: rhys &lt;AT&gt; therhys.co.uk'),
        ),
    );
}

sub page_body {
    &page(content => div(&content),);
}

print html (CGI::head(&page_head('Rhys Adams - About')), CGI::body(&page_body),
);
