#!/usr/bin/perl

use CGI ':standard';

use Text::Markdown qw/ markdown /;

use lib '.';
use shared ();

print CGI::header ("text/html;charset=UTF-8");

my $POST_DIR = "posts";

use Data::Dumper;

sub posts {
    my @tags = @_;

    my @out;

    for (<$POST_DIR/*.{md,html}>) {
        ( my $fname = $_ ) =~ s:$POST_DIR/::g;

        open FH, '<', $_;
        my %conf;
        until ( ( my $line = <FH> ) =~ /^----*/ ) {
            next unless $line =~ /.*:.*/g;    # Skip unless there is key: value

            my ( $k, $v ) = split /:\s*/, $line;
            $conf{ $k } = $v;
        }

        $conf{ Tags } = [split ',\s*', $conf{ Tags }];

        if (@tags) {
            for my $tag ( @{ $conf{ Tags } } ) {
                chomp $tag;
                if ( grep { $_ eq $tag } @tags ) {
                    push @out, [$fname, \%conf];
                    last;
                }
            }
        } else {
            push @out, [$fname, \%conf];
        }

        close FH;
    }

    sort { $$b[1]{ Published } cmp $$a[1]{ Published } } @out;    # Return sorted by publish date.
}

sub linkify_imgs {
    my ($data) = @_;

    $data =~ s:<img.*?src="(.*?)".*?>:<a href="$1">$&</a>:mg;

    $data;
}

sub md2html {
    my $out = markdown (
        $_[0],
        {
            empty_element_suffix => '>',
            tab_width            => 2
        }
    );

    $out =~ s/<code>/<code class="prettyprint">/g;
    $out = &linkify_imgs ($out);

    $out,
        script (
        {
            src => 'https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.js',
        },
        ''
        );
}

sub load_post {
    my ($fname) = @_;

    $fname =~ s:/::g;    # Be safe and remove any slashes whatsoever.

    $fname = "$POST_DIR/$fname";

    open FH, '<', $fname or return h1 ("Unknown post!");

    my %conf;
    until ( ( my $line = <FH> ) =~ /^----*/ ) {
        next unless $line =~ /.*:.*/g;    # Skip unless there is key: value

        my ( $k, $v ) = split /:\s*/, $line;
        $conf{ $k } = $v;
    }
    $conf{ Tags } = [split ',\s*', $conf{ Tags }];
    my $data = join '', <FH>;
    close FH;

    my $infobar = div (
        {
            class => 'post_infobar'
        },
        p ("Published: $conf{Published}"),
        "Tags: ",
        ( map { a ( { class => 'topic_round', href => "/blog.pl?tags=$_", }, $_ ) } @{ $conf{ Tags } } ),
    );

    if ( $fname =~ /\.md$/ ) {
        return div (
            {
                class => 'post_body centre_page',
            },
            $infobar,
            &md2html ($data),
        );
    } elsif ( $fname =~ /\.html/ ) {
        return $infobar,
            div (
            {
                class => 'post_body centre_page',
            },
            &linkify_imgs ($data),
            );
    }

    return h1 ("Unknown post type!");
}

sub posts_page {
    (
        div (
            {
                class => 'title centre'
            },

            h1 ( { class => 'centre' }, 'Blog Posts' ),
        ),

        div (
            {
                class => 'centre_page'
            },
            ul (
                map {
                    li (
                        a (
                            {
                                href => "/blog.pl?post=$$_[0]",
                            },
                            "$$_[1]{Title} - $$_[1]{Published}",
                        ),
                        map { a ( { class => 'topic_round', href => "/blog.pl?tags=$_" }, $_ ) } @{ $$_[1]{ Tags } },
                    )
                } &posts ( split /,\s*/, param ('tags') ),
            ),
        ),
    );
}

sub index_body {
    page(&navbar, div(&posts_page), div(p()), &footer);
}

sub post_body {
    my ($post_name) = @_;
    
    page(&navbar, div(&load_post ($post_name)), div(p()), &footer);
}

if ( my $post_name = param ('post') ) {
    print html ( CGI::head ( &page_head ( 'Rhys Adams - ' . param ('post') ) ),
        CGI::body ( &post_body ($post_name) ), );
} else {
    print html ( CGI::head ( &page_head ('Rhys Adams - Blog') ), CGI::body (&index_body), );
}
