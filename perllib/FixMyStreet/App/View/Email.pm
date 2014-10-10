package FixMyStreet::App::View::Email;
use base 'Catalyst::View::TT';

use strict;
use warnings;

use mySociety::Locale;
use FixMyStreet;

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.txt',
    INCLUDE_PATH       => [          #
        FixMyStreet->path_to( 'templates', 'email', 'base' ),
    ],
    ENCODING       => 'utf8',
    render_die     => 1,
    expose_methods => ['loc'],
);

=head1 NAME

FixMyStreet::App::View::Email - TT View for FixMyStreet::App

=head1 DESCRIPTION

TT View for FixMyStreet::App.

=cut

=head2 loc

    [% loc('Some text to localize') %]

Passes the text to the localisation engine for translations.

=cut

sub loc {
    my ( $self, $c, @args ) = @_;
    return _(@args);
}

1;

