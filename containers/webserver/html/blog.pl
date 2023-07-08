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
        close FH;

        $conf{Tags} = [split ',\s*', $conf{Tags}]
          ;    # Split the tags string by comma into a list.

        if (@tags) {
            for my $tag (@{ $conf{Tags} })
            {    # Show only relevant tags if specified.
                chomp $tag;
                if (grep { $_ eq $tag } @tags) {
                    push @out, [$fname, \%conf];
                    last;
                }
            }
        } else {
            push @out, [$fname, \%conf];
        }

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
            table({
                    id => 'blog_table',
                },
                Tr(th('Title'), th('Published'), th('Tags'),),
                map {
# For every tag make a table row with the link/name, publish date, and the topic filters.
                    Tr(
                        td(a({
                                href => "/post?post=$$_[0]",
                            },
                            "$$_[1]{Title}",
                        )),
                        td($$_[1]{Published}),
                        td(
                            map {
                                a({
                                        class => 'topic_round',
                                        href  => "/blog?tags=$_"
                                    },
                                    $_
                                )
                            } @{ $$_[1]{Tags} }
                        ),
                    )
                } &posts(split /,\s*/, param('tags')),
            ),
        ),
    );
}

sub index_body {
    &page(content => div(&content));
}

print html (CGI::head(&page_head('Rhys Adams - Blog')), CGI::body(&index_body));
