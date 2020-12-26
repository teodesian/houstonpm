package Theme;

use strict;
use warnings;

no warnings 'experimental';
use feature qw{signatures};

use File::Basename qw{basename};

use lib 'lib';
use Trog::Routes::HTML;

our $default_title = 'Houston Perl Mongers';

our %routes = (
    '/about.html' => {
        method   => 'GET',
        callback => sub {Trog::Routes::HTML::redirect_permanent('/about') },
    },
    '/meetings.html' => {
        method   => 'GET',
        callback => \&Trog::Routes::HTML::series,
        data     => { id => 1609008204, in_series => 1 },
    },
    '/announce_meeting.html' => {
        method   => 'GET',
        callback => \&Trog::Routes::HTML::series,
        data     => { id => 1609008204, in_series => 1, limit => 1 },
    },
    '/sponsors.html' => {
        method   => 'GET',
        callback => \&sponsors,
    },
    '/faqs.html' => {
        method   => 'GET',
        callback => \&faq,
    },
    '/projects/index.html' => {
        method   => 'GET',
        callback => \&Trog::Routes::HTML::series,
        data     => { id => 1608661217, in_series => 1 },
    },
    '/talks/mostrecent.html' => {
        method   => 'GET',
        callback => \&Trog::Routes::HTML::posts,
        data     => { tag => ['presentations'], limit => 1 },
    },
    '/talks/index.html' => {
        method   => 'GET',
        callback => \&Trog::Routes::HTML::series,
        data     => { id => 1608661368, in_series => 1 },
    },
    '/styles/houston.css' => {
        method   => 'GET',
        callback => sub {Trog::Routes::HTML::redirect_permanent('/themes/houston.pm/styles/houston.css') },
    },
    '/talks/(\d.*)' => {
        method   => 'GET',
        callback => sub {
            my ($query) = @_;
            Trog::Routes::HTML::redirect_permanent("/assets/talks/$query->{fragment}")
        },
        captures => ['fragment'],
    },
);

my $processor = Text::Xslate->new(
    path => 'www/themes/houston.pm/templates',
);

my %paths = (
    '/talks/index.html'      => 'Past Meetings',
    '/talks/mostrecent.html' => 'Latest Meeting',
    '/projects/index.html'   => 'Group Projects',
);

sub path_to_tile ($path) {
    return $paths{$path} ? $paths{$path} : $path;
}

sub sponsors ($args, $render_cb) {
    my $out = $processor->render('sponsors.tx');
    return Trog::Routes::HTML::index($args,$render_cb, $out);
}

sub faq ($args, $render_cb) {
    my $out = $processor->render('faq.tx');
    return Trog::Routes::HTML::index($args,$render_cb, $out);
}

1;
