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

            h1({ class => 'centre' }, 'Projects'),
        ),

        div({
                class => 'about centre_page'
            },

            txt('I have done many projects, here are a few of my favourites:'),
            ul(
                li(
                    a(
                        { href => 'https://github.com/radams15/RhysLang4' },
                        "RhysLang"
                    ),
' - A programming language that can compile into x86 assembly, from 8086 assembly up to modern x86_64 assembly.',
                    '(ASM, Perl)'
                ),
                li(
                    a(
                        { href => 'https://github.com/radams15/RhysOS4' },
                        "RhysOS"
                    ),
' - A 16-bit operating system written in C for the 8086. Tested on my Toshiba t3100e.
Implements: bootloader, filesystem (USTAR), VFS, graphics and text modes, CLI.',
                    '(ASM, C)'
                ),
                li(
                    a(
                        { href => 'https://github.com/radams15/DMachine' },
                        "DMachine"
                    ),
' - An equivalent of distrobox for Mac OSX docker containers.',
                    '(Perl)'
                ),
                li(
                    a(
                        { href => 'https://github.com/radams15/netkit-sdk' },
                        "Netkit SDK"
                    ),
                    ' - A program to generate Netkit-JH labs with code.',
                    '(Perl)'
                ),
            ),
        ),
    );
}

sub page_body {
    &page(content => div(&content),);
}

print html (CGI::head(&page_head('Rhys Adams - About')), CGI::body(&page_body),
);
