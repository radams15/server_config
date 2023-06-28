use CGI ':standard';

use Exporter 'import';

our @EXPORT_OK = qw/ page_head navbar txt/;

my %MENU = (
	Home => '/',
	About => '/about.pl',
	Links => {
				'Cloud' => '/cloud/',
				'Jellyfin' => '/jellyfin/',
				'Transmission' =>  '/transmission',
				'Sonarr' =>  '/sonarr/',
				'Radarr' =>  '/radarr/',
				'Jackett' =>  '/jackett/',
				'Jenkins' => '/jenkins/',
				'Github' => 'https://github.com/radams15',
				'Github (University)' => 'https://github.com/rhys-cyber',
	},
);
my @order = qw/ Home About Links /;

sub page_head {
	my ($title) = @_;
	
	$title = 'UNKNOWN TITLE' unless $title;
	
	(
		title($title),
		Link({
		  rel   => 'stylesheet',
		  type  => 'text/css',
		  href   => 'static/solarized.css',
		}),
		Link({
		  rel   => 'stylesheet',
		  type  => 'text/css',
		  href   => 'static/style.css',
		}),
		Link({
		  rel   => 'stylesheet',
		  type  => 'text/css',
		  href   => 'static/dropdown.css',
		}),
	);
}

sub navbar_items {
	my ($links, $order) = @_;
	my @out;
		
	for (@$order) {
		my $val = $$links{$_};
		
		if(ref $val eq 'HASH') {
			push @out, div(
				{
					class=>'dropdown'
				},
				div(
					{
						class=>'dropbtn'
					},
					$_,
				),
				div(
					{
						class => 'dropdown-content'
					},
					&navbar_items($val, [keys %$val]),
				)
			);
		} else {
			push @out, a(
				{
					href=>$val
				},
				$_,
			);
		}
	}
	
	@out;
}

sub navbar {
	(
		div({
			class => 'navbar'
		}, 
		&navbar_items(\%MENU, \@order),
		),
	);
}

sub txt {
	p({
		class => 'text'
	}, @_);
}

1;