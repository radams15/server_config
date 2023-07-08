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

            h1({ class => 'centre' }, 'About'),
        ),

        div({
                class => 'about centre_page'
            },

            h2({ class => 'centre' }, 'Me'),

            txt(
"I'm currently studying BSc Cyber Security at the University of Warwick."
            ),
            txt(
"My favourite areas include binary exploitation and reverse engineering, as well as network design and implementation."
            ),
            txt(
"Of course, I also thouroughly enjoy programming with a variety of languages and tools:"
            ),
            ul(
                # Languages
                li_a('Perl', 'https://perl.org'),
                ul(
                    li_a('Mojolicious', 'https://mojolicious.org'),
                    li_a('CGI.pm',      'https://metacpan.org/pod/CGI'),
                ),
                li_a('Python', 'https://python.org'),
                li('C++'),
                ul(
                    li_a('WxWidgets', 'https://wxwidgets.org'),
                    li_a('Qt',        'https://qt.io'),
                ),
                li('C'),

                # Tools
                li_a('Podman', 'https://podman.io'),
                li_a('Docker', 'https://docker.io'),
                li_a('Linux',  'https://kernel.org'),
            ),
            txt(
"Some of my other interests include vintage computers, electronics, and collecting music on a variety of formats."
            ),

            h2({ class => 'centre' }, 'The Website'),

            txt(
"These pages are written from scratch using Perl's CGI.pm which allows a very light, reasonably powerful backend without the need to touch any PHP."
            ),
            txt(
"This site is hosted on my home 'server' - a 2012 HP Elitebook 8570p running RHEL 8. I use Podman to run various containers, including:"
            ),
            ul(
                li('An NGINX reverse proxy'),
                li('Cloudflare tunnels to allow outside access to this site'),
                li('Apache httpd with mod_cgi'),
            ),
        ),
    );
}

sub page_body {
    &page(content => div(&content));
}

print html (CGI::head(&page_head('Rhys Adams - About')), CGI::body(&page_body));
