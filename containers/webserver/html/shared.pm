use CGI ':standard';

use Exporter 'import';

our @EXPORT_OK = qw/ page_head navbar footer txt http_header/;

my %MENU = (
    Home  => '/',
    About => '/about.pl',
    Links => {
        'Cloud'               => '/cloud/',
        'Jellyfin'            => '/jellyfin/',
        'Transmission'        => '/transmission',
        'Sonarr'              => '/sonarr/',
        'Radarr'              => '/radarr/',
        'Jackett'             => '/jackett/',
        'Jenkins'             => '/jenkins/',
        'Github'              => 'https://github.com/radams15',
        'Github (University)' => 'https://github.com/rhys-cyber',
    },
    Blog => '/blog.pl',
);
my @order = qw/ Home About Blog Links /;

my @stylesheets = qw: static/solarized.css static/style.css static/dropdown.css static/post.css :;

sub page_head {
    my ($title) = @_;

    $title = 'UNKNOWN TITLE' unless $title;

    (
        title ($title),
        map { Link ( { rel => 'stylesheet', type => 'text/css', href => $_, } ) } @stylesheets,
    );
}

sub navbar_items {
    my ( $links, $order ) = @_;
    my @out;

    for (@$order) {
        my $val = $$links{ $_ };

        if ( ref $val eq 'HASH' ) {
            push @out,
                div (
                {
                    class => 'dropdown'
                },
                div (
                    {
                        class => 'dropbtn'
                    },
                    $_,
                ),
                div (
                    {
                        class => 'dropdown-content'
                    },
                    &navbar_items ( $val, [sort keys %$val] ),
                )
                );
        } else {
            push @out,
                a (
                {
                    href => $val
                },
                $_,
                );
        }
    }

    @out;
}

sub navbar {
    (
        div (
            {
                class => 'navbar',
                id    => 'main_nav',
            },
            &navbar_items ( \%MENU, \@order ),
            a ( { href => "javascript:void(0);", class => 'icon', onclick => 'onDropDown()' }, 'Menu' ),
        ),
    );
}

sub txt {
    p (
        {
            class => 'text'
        },
        @_
    );
}

sub footer {
    div (
        {
            class => 'footer',
        },
        txt ( 'Copyright Rhys Adams, 2022-'.( 1900 + (localtime)[5]) ),
        ),
        script (
        'function onDropDown() {
  var x = document.getElementById("main_nav");
  if (x.className === "navbar") {
    x.className += " responsive";
  } else {
    x.className = "navbar";
  }
}'
        );
}


sub http_header {
    CGI::header ("text/html;charset=UTF-8");
}
1;
