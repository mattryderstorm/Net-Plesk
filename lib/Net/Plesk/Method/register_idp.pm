package Net::Plesk::Method::register_idp;

use strict;

use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );

@ISA = qw( Net::Plesk::Method );
$VERSION = '0.01';

$DEBUG = 0;

=head1 NAME

Net::Plesk::Method::client_ippool_add_ip - Perl extension for Plesk XML
Remote API client ippool addition

=head1 SYNOPSIS

  use Net::Plesk::Method::client_ippool_add_ip

  my $p = new Net::Plesk::Method::client_ippool_add_ip ( $clientID, $ipaddress );

=head1 DESCRIPTION

This module implements an interface to construct a request for a ippool
addition to a client using SWSOFT's Plesk.

=head1 METHODS

=over 4

=item init args ...

Initializes a Plesk client ippool_add_ip.  The I<clientID> and I<ipaddress>
options are required.
=cut

sub api_version { '1.5.2.1' }

sub init {
  my ($self,$idp) = @_;
  $$self = join("\n",
              '<sso>',
              '<register>',
              '<idp-url>'.$idp.'</idp-url>',
	            '</register>',
              '</sso>'
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

