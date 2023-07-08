use CGI ':standard';

use Exporter 'import';

our @EXPORT_OK = qw/ page_head navbar footer txt http_header page /;

my %MENU = (
    Home     => '/',
    About    => '/about',
    Projects => '/projects',
    Links    => {
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
    Blog    => '/blog',
    Contact => '/contact',
);
my @order = qw/ Home About Projects Blog Links Contact /;

my @stylesheets =
  qw: static/colours.css static/style.css static/dropdown.css static/post.css :;

sub page_head {
    my ($title) = @_;

    $title = 'UNKNOWN TITLE' unless $title;

    (
        title($title),
        map { Link({ rel => 'stylesheet', type => 'text/css', href => $_, }) }
          @stylesheets,    # Link to all the stylesheets
    );
}

sub navbar_items {
    my ($links, $order) = @_;
    my @out;

    for (@$order) {
        my $val     = $$links{$_};
        my $current = $ENV{REQUEST_URI} eq $val;

        if (ref $val eq 'HASH') { # Make a dropdown menu as shown by W3 schools.
            push @out,
              div({
                    class => 'dropdown'
                },
                div({
                        class => 'dropbtn'
                    },
                    $_,
                ),
                div({
                        class => 'dropdown-content'
                    },
                    &navbar_items($val, [sort keys %$val]),
                )
              );
        } else {    # Otherwise add a link to the item.
            push @out, a({
                    href  => $val,
                    class => ($current ? 'nav_selected' : '')
                    ,    # If the url is the same as current one highlight it.
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
                id => 'main_nav'
            },
            &navbar_items(\%MENU, \@order),
            a({
                    href    => "javascript:void(0);",
                    class   => 'icon',
                    onclick =>
                      'onDropDown()' # Collapsed menu button calls function to show the menu.
                },
                'Menu'
            ),
        ),
    );
}

sub txt {
    p({
            class => 'text'
        },
        @_
    );
}

sub header {
    h1({ id => 'header_title' }, 'Rhys Adams')
      ,    # The top header of the page with the masthead and motto.
      p({ id => 'motto' },
        'Vintage computing, cyber security and other interesting stuff.');
}

sub footer {
    div(    # The footer of the page with copyright info and scripts.
        { id => 'copyright' },
        txt('Copyright Rhys Adams, 2022-' . (1900 + (localtime)[5])),
        script(
            { type => 'text/javascript' },
            'function onDropDown() {
  var x = document.getElementById("main_nav");
  if (x.className === "navbar") {
    x.className += " responsive";
  } else {
    x.className = "navbar";
  }
}'
        )
    );
}

sub sidebar {
    # Sidebar is blank by default.
    p();
}

sub page {
    my %args = @_;

    div(    # Build a page with the correct classes.
        { class => 'page' },
        div({ class => 'header' },  $args{header}  // &header),
        div({ class => 'navbar' },  $args{navbar}  // &navbar),
        div({ class => 'sidebar' }, $args{sidebar} // &sidebar),
        div({ class => 'content' }, $args{content} // p()),
        div({ class => 'footer' },  $args{footer}  // &footer)
    );
}

sub http_header {
    CGI::header("text/html;charset=UTF-8");    # Enable unicode on all pages.
}
1;
