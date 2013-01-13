package Net::Plesk::Method::mailbox_add;

use strict;

use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );
use constant api_version => '1.4.2.0';

@ISA = qw( Net::Plesk::Method );
$VERSION = '0.01';
$DEBUG = 0;

sub init {
  my ($self, %args) = @_;

  my $mailbox_enabled  = $args{password} ? 'true' : 'false';

  $$self = join "\n" => (
    '<mail>',
      '<create>',
        '<filter>',
          "<domain_id>$args{domain_id}</domain_id>",
          '<mailname>',

            "<name>$args{username}</name>",
            "<mailbox><enabled>$mailbox_enabled</enabled></mailbox>",
            $self->make_redirect(%args),
            $self->defined_element(password => $args{password}),

          '</mailname>',
        '</filter>',
      '</create>',
    '</mail>',
  );
}

sub make_redirect {
  my ($self, %args) = @_;

  return unless $args{redirect};

  my $redirect_enabled = $args{redirect} ? 'true' : 'false';

  my $redirect_info = sprintf "<redirect><enabled>%s</enabled>%s</redirect>", $redirect_enabled, $self->defined_element(address => $args{redirect});

  return $redirect_info;
}

=head1 NAME

Net::Plesk::Method::mail_add - Perl extension for Plesk XML Remote API mail addition

=head1 SYNOPSIS

  use Net::Plesk::Method::mail_add

  my $p = new Net::Plesk::Method::mail_add ( $domainID, $mailbox, $passwd );

  $request = $p->endcode;

=head1 DESCRIPTION

This module implements an interface to construct a request for a mailbox
addition using SWSOFT's Plesk.

=head1 METHODS

=over 4

=item init args ...

Initializes a Plesk mail_add object.  The I<domainID>, I<mailbox>,
and I<passwd> options are required.

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

