use CGI ':standard';

use Exporter 'import';

our @EXPORT_OK = qw/ page_head navbar footer txt/;

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
	Blog => '/blog.pl',
);
my @order = qw/ Home About Blog Links /;

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
					&navbar_items($val, [sort keys %$val]),
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
			class => 'navbar',
			id => 'main_nav',
		}, 
		&navbar_items(\%MENU, \@order),
		a({href=>"javascript:void(0);", class => 'icon', onclick => 'onDropDown()'}, 'Menu'),
		),
	);
}

sub txt {
	p({
		class => 'text'
	}, @_);
}

sub footer {
	script('function onDropDown() {
  var x = document.getElementById("main_nav");
  if (x.className === "navbar") {
    x.className += " responsive";
  } else {
    x.className = "navbar";
  }
} ');
}

1;