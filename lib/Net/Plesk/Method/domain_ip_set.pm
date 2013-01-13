package Net::Plesk::Method::domain_ip_set;

use strict;

use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );

@ISA = qw( Net::Plesk::Method );
$VERSION = '0.02';

$DEBUG = 0;

sub api_version { '1.4.2.0' }

sub init {
  my ($self, %args) = @_;

  my $xml = join "\n" => (
    "<domain>",
      "<set>",
        "<filter>",
          "<domain_name>$args{domain}</domain_name>",
        "</filter>",
        "<values>",
          "<gen_setup>",
            "<dns_ip_address>$args{ip_address}</dns_ip_address>",
          "</gen_setup>",
        "</values>",
      "</set>",
    "</domain>",
  );

  $$self = $xml;
}

=head1 NAME

Net::Plesk::Method::domain_add - Perl extension for Plesk XML Remote API domain addition

=head1 SYNOPSIS

  use Net::Plesk::Method::domain_add

  my $p = new Net::Plesk::Method::domain_add ( $clientID, 'domain.com' );

  $request = $p->endcode;

=head1 DESCRIPTION

This module implements an interface to construct a request for a domain
addition using SWSOFT's Plesk.

=head1 METHODS

=over 4

=item init args ...

Initializes a Plesk domain_add object.  The I<domain>, I<client>, and
$<ip_address> options are required.

=cut


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

