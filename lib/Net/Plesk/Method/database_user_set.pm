package Net::Plesk::Method::database_user_set;

use strict;

use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );

@ISA = qw( Net::Plesk::Method );
$VERSION = '0.01';

$DEBUG = 0;

=head1 NAME

Net::Plesk::Method::domain_get - Perl extension for Plesk XML Remote API domain 
                         information retreival

=head1 SYNOPSIS

  use Net::Plesk::Method::add_database

  my $p = new Net::Plesk::Method::add_database ( 'domain.com' );

=head1 DESCRIPTION

This module implements an interface to construct a request for domain
information retreival using SWSOFT's Plesk.

=head1 METHODS

=over 4

=item init args ...

Initializes a Plesk domain_get object.  The I<domain> option is required.

=cut

sub api_version { '1.4.2.0' }

sub init {
  my ($self, %args) = @_;

  $$self = join "\n" => (
    '<database>',
      '<set-db-user>',
        "<id>$args{user_id}</id>",
        "<password>" . $self->encode( $args{password} ) . "</password>",
      '</set-db-user>',
    '</database>'
  );
}

=back

=head1 BUGS

  Creepy crawlies.

=head1 SEE ALSO

SWSOFT Plesk Remote API documentation (1.4.0.0 or later)

=head1 AUTHOR

Jeff Finucane E<lt>jeff@cmh.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 Jeff Finucane

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

