package FixMyStreet::Cobrand::Southampton;
use base 'FixMyStreet::Cobrand::Default';

use strict;
use warnings;

use Carp;
use URI::Escape;
use mySociety::VotingArea;

sub site_restriction {
    return ( "and council='2567'", 'southampton', { council => '2567' } );
}

sub base_url {
   my $base_url = mySociety::Config::get('BASE_URL');
   if ($base_url !~ /southampton/) {
       $base_url =~ s{http://(?!www\.)}{http://southampton.}g;
       $base_url =~ s{http://www\.}{http://southampton.}g;
   }
   return $base_url;
}

sub site_title {
    my ( $self ) = @_;
    return 'Southampton City Council FixMyStreet';
}

sub enter_postcode_text {
    my ( $self ) = @_;
    return 'Enter a Southampton postcode, or street name and area';
}

sub council_check {
    my ( $self, $params, $context ) = @_;

    my $councils;
    if ($params->{all_councils}) {
        $councils = $params->{all_councils};
    } elsif (defined $params->{lat}) {
        my $parent_types = $mySociety::VotingArea::council_parent_types;
        $councils = mySociety::MaPit::call(
            'point',
            "4326/$params->{lon},$params->{lat}",
            type => $parent_types
        );
    }
    my $council_match = defined $councils->{2567};
    if ($council_match) {
        return 1;
    }
    my $url = 'http://www.fixmystreet.com/';
    $url .= 'alert' if $context eq 'alert';
    $url .= '?pc=' . URI::Escape::uri_escape_utf8($self->{c}->req->param('pc'))
        if $self->{c}->req->param('pc');
    my $error_msg = "That location is not covered by Southampton.
Please visit <a href=\"$url\">the main FixMyStreet site</a>.";
    return ( 0, $error_msg );
}

# All reports page only has the one council.
sub all_councils_report {
    return 0;
}

sub disambiguate_location {
    my ( $self, $s ) = @_;
    $s = "ll=50.913822,-1.400493&spn=0.084628,0.15701&$s";
    return $s;
}

sub recent_photos {
    my ($self, $num, $lat, $lon, $dist) = @_;
    $num = 2 if $num == 3;
    return Problems::recent_photos( $num, $lat, $lon, $dist );
}

sub tilma_mid_point {
    return 189;
}

1;

