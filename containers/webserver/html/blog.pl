#!/usr/bin/perl

use CGI ':standard';

use Text::Markdown qw/ markdown /;

use lib '.';
use shared ();

print &http_header;

my $POST_DIR = "posts";

sub posts {
    my @tags = @_;

    my @out;

    for (<$POST_DIR/*.{md,html}>) {
        (my $fname = $_) =~ s:$POST_DIR/::g;

        open FH, '<', $_;
        my %conf;
        until ((my $line = <FH>) =~ /^----*/) {
            next unless $line =~ /.*:.*/g;    # Skip unless there is key: value

            my ($k, $v) = split /:\s*/, $line;
            $conf{$k} = $v;
        }

        $conf{Tags} = [split ',\s*', $conf{Tags}];

        if (@tags) {
            for my $tag (@{ $conf{Tags} }) {
                chomp $tag;
                if (grep { $_ eq $tag } @tags) {
                    push @out, [$fname, \%conf];
                    last;
                }
            }
        } else {
            push @out, [$fname, \%conf];
        }

        close FH;

    }
    sort { $$b[1]{Published} cmp $$a[1]{Published} }
      @out;    # Return sorted by publish date.
}

sub content {
    (
        div({
                class => 'title centre'
            },

            h1({ class => 'centre' }, 'Blog Posts'),
        ),

        div({
                class => 'centre_page'
            },
            ul(
                map {
                    li(
                        a({
                                href => "/post.pl?post=$$_[0]",
                            },
                            "$$_[1]{Title} - $$_[1]{Published}",
                        ),
                        map {
                            a({
                                    class => 'topic_round',
                                    href  => "/blog.pl?tags=$_"
                                },
                                $_
                            )
                        } @{ $$_[1]{Tags} },
                    )
                } &posts(split /,\s*/, param('tags')),
            ),
        ),
    );
}

sub index_body {
    &page(content => div(&content),);
}

print html (CGI::head(&page_head('Rhys Adams - Blog')),
    CGI::body(&index_body),);
