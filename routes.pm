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
        callback => \&Trog::Routes::HTML::posts,
        data     => { tag => ['meetings'] },
    },
    '/announce_meeting.html' => {
        method   => 'GET',
        callback => \&Trog::Routes::HTML::posts,
        data     => { tag => ['meetings'], limit => 1 },
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
        callback => \&Trog::Routes::HTML::posts,
        data     => { tag => ['project'] },
    },
    '/mostrecent.html' => {
        method   => 'GET',
        callback => \&Trog::Routes::HTML::posts,
        data     => { tag => ['presentations'], limit => 1 },
    },
    '/talks/index.html' => {
        method   => 'GET',
        callback => \&Trog::Routes::HTML::posts,
        data     => { tag => ['presentations'] },
    },
    '/styles/houston.css' => {
        method   => 'GET',
        callback => sub {Trog::Routes::HTML::redirect_permanent('/themes/houston.pm/styles/houston.css') },
    },
);

my $processor = Text::Xslate->new(
    path => 'www/themes/houston.pm/templates',
);

my %paths = (
    '/meetings.html'         => 'Past & Upcoming Meetings',
    '/announce_meeting.html' => 'Latest Meeting',
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
