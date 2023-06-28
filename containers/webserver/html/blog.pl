#!/usr/bin/perl

use CGI ':standard';

use Text::Markdown qw/ markdown /;

use lib '.';
use shared ();

print CGI::header;

my $POST_DIR = "posts";

use Data::Dumper;

sub posts {
	my @out;
	
	for (<$POST_DIR/*.{md,html}>) {
		(my $fname = $_) =~ s:$POST_DIR/::g;
		
		open FH, '<', $_;
		my %conf;
		until((my $line = <FH>) =~ /^----*/) {
			next unless $line =~ /.*:.*/g; # Skip unless there is key: value
			
			my ($k, $v) = split /:\s*/, $line;
			$conf{$k} = $v;
		}
		
		$conf{Tags} = [split ',\s*', $conf{Tags}];
		
		push @out, [$fname, \%conf];
		
		close FH;
	}
	
	
	sort {$$b[1]{Published} cmp $$a[1]{Published}} @out; # Return sorted by publish date.
}

sub load_post {
	my ($fname) = @_;
	
	$fname =~ s:/::g; # Be safe and remove any slashes whatsoever.
	
	$fname = "$POST_DIR/$fname";
	
	open FH, '<', $fname or return h1("Unknown post!");
	until((<FH>) =~ /----*/){}; # Skip the header
	my $data = join '', <FH>;
	close FH;
	
	if($fname =~ /\.md$/) {
		return div(
			{
				class => 'post_body centre_page',
			},
			markdown($data, {
				empty_element_suffix => '>',
				tab_width => 2
			})
		);
	} elsif($fname =~ /\.html/) {
		return div(
			{
				class => 'post_body centre_page',
			},
			$data
		);
	}
	
	return h1("Unknown post type!");
}

sub page {
	(
		div({
				class => 'title centre'
			},
			
			h1({ class=>'centre' }, 'Blog Posts'),
		),
		
		div({
				class => 'centre_page'
			},
			ul(
				map {
					li(
						a(
							{
								href => "/blog.pl?post=$$_[0]",
							},
							"$$_[1]{Title} - $$_[1]{Published}",
						),
						map {
							p(
								{
									class => 'topic_round',
								},
								$_
							)
						} @{$$_[1]{Tags}},
					)
				} &posts,
			),
		),
	);
}

sub index_body {
	(
		&navbar,
		&page,
		&footer,
	);
}

sub post_body {
	my ($post_name) = @_;
	
	(
		&navbar,
		&load_post($post_name),
		&footer,
	);
}


if(my $post_name = param('post')) {
	print html (
		CGI::head(&page_head('Rhys Adams - '.param('post'))),
		CGI::body(&post_body($post_name)),
	);
} else {
	print html (
		CGI::head(&page_head('Rhys Adams - Blog')),
		CGI::body(&index_body),
	);
}
