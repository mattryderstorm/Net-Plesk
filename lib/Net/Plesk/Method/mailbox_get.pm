package Net::Plesk::Method::mailbox_get;

use strict;
use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );
use constant api_version  => '1.5.2.1';

@ISA     = qw( Net::Plesk::Method );
$VERSION = '0.01';
$DEBUG   = 0;

# returns mailbox specific information

sub init {
  my ($self, %args) = @_;

  $$self = join "\n" => (
    '<mail>',
      '<get_info>',
        '<filter>',
          "<domain_id>$args{domain_id}</domain_id>",
          "<name>$args{username}</name>",
        '</filter>',
        '<mailbox/>',
        '<redirect/>',
        '<aliases/>',
        '<permissions/>',
      '</get_info>',
    '</mail>',
  );
}

=head1 NAME

Net::Plesk::Method::mail_get_account_attributes - Perl extension for Plesk XML Remote API mail addition

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

