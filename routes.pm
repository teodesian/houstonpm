package Theme;

use strict;
use warnings;

no warnings 'experimental';
use feature qw{signatures};

use File::Basename qw{basename};

use lib 'lib';
use Trog::Routes::HTML;

our $default_title = 'Houston Perl Mongers';
our $default_image = 'img/icon/houstonpm.png';
our $display_name  = 'Houston Perl Mongers';
our $description   = 'Houston Perl Mongers';
our $default_tags  = 'houston.pm, houston, perl, mongers, Net::Jabber::Bot, Device::USB::LibUSB';

our $show_madeby = 1;
our $twitter_account = 'houstonpm';
our $fb_app_id       = 'bogus';

our %routes = (
    '/about.html' => {
        method   => 'GET',
        callback => sub {Trog::Routes::HTML::redirect_permanent('/about') },
    },
    '/meetings.html' => {
        method   => 'GET',
        callback => \&Trog::Routes::HTML::series,
        data     => { id => 'eb64957c-14d7-11ec-852a-f1cd345321ea', in_series => 1, exclude_tags => ['series','about'] },
    },
    '/announce_meeting.html' => {
        method   => 'GET',
        callback => \&Trog::Routes::HTML::series,
        data     => { id => 'eb64957c-14d7-11ec-852a-f1cd345321ea', in_series => 1, exclude_tags => ['series','about'], limit => 1 },
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
        data     => { id => 'e9941181-14d7-11ec-852a-c5617e3415e6', in_series => 1, exclude_tags => ['series','about'] },
    },
    '/talks/mostrecent.html' => {
        method   => 'GET',
        callback => \&Trog::Routes::HTML::series,
        data     => { id => 'e91ce133-14d7-11ec-852a-a69c982403ec', in_series => 1, exclude_tags => ['series','about'], limit => 1 },
    },
    '/talks/index.html' => {
        method   => 'GET',
        callback => \&Trog::Routes::HTML::series,
        data     => { id => 'e91ce133-14d7-11ec-852a-a69c982403ec', in_series => 1, exclude_tags => ['series','about'] },
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

sub sponsors ($args) {
    my $out = $processor->render('sponsors.tx');
    return Trog::Routes::HTML::index($args, $out);
}

sub faq ($args) {
    my $out = $processor->render('faq.tx');
    return Trog::Routes::HTML::index($args, $out);
}

1;
