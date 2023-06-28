#!/usr/bin/perl

use CGI ':standard';

use Text::Markdown qw/ markdown /;

use lib '.';
use menu ();

print CGI::header;

my $POST_DIR = "posts";

sub posts {
	my @out;
	
	for (<$POST_DIR/*.md>) {
		(my $fname = $_) =~ s:$POST_DIR/::g;
		
		open FH, '<', $_;
		my $name = <FH>;
		$name =~ s/#\s+//g;
		
		push @out, [$fname, $name];
		
		close FH;
	}
	
	for (<$POST_DIR/*.html>) {
		(my $fname = $_) =~ s:$POST_DIR/::g;
		
		open FH, '<', $_;
		my $name;
		while(<FH>) {
			if(/<title>(.*?)<\/title>/g) {
				$name = $1;
				break;
			}
		}
		close FH;
		$name = $fname unless $name;

		push @out, [$fname, $name];
	}
	
	
	@out;
}

sub load_post {
	my ($fname) = @_;
	
	$fname =~ s:/::g; # Be safe and remove any slashes whatsoever.
	
	$fname = "$POST_DIR/$fname";
	
	open FH, '<', $fname or return h1("Unknown post!");
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
							$$_[1]
						),
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
	);
}

sub post_body {
	my ($post_name) = @_;
	
	(
		&navbar,
		&load_post($post_name),
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
