package Net::Plesk::Method::mail_redirect;

use strict;
use vars qw( $VERSION $AUTOLOAD $DEBUG );
use constant api_version => '1.5.2.1';
use parent 'Net::Plesk::Method';

$VERSION = '0.01';
$DEBUG   = 0;

sub init {
  my ($self, %args) = @_;

  my $enabled = $args{active} ? 'true' : 'false';
  my $dest    = $self->encode( $args{destination} );

  $$self = join "\n" => (
    '<mail>',
      '<update>',
        '<set>',
          '<filter>',

          "<domain_id>$args{domain_id}</domain_id>",
          '<mailname>',

            "<name>$args{username}</name>",
            '<redirect>',
              "<enabled>$enabled</enabled>",
              "<address>$dest</address>",
            '</redirect>',

          '</mailname>',

          '</filter>',
        '</set>',
      '</update>',
    '</mail>',
  );
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

