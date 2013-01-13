package Net::Plesk::Method::mail_list_del;

use strict;
use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );
use constant api_version => '1.5.2.1';

@ISA     = qw( Net::Plesk::Method );
$VERSION = '0.01';
$DEBUG   = 0;

sub init {
  my ($self, %args) = @_;

  $$self = join  "\n" => (
    '<maillist>',
      '<del-list>',
        '<filter>',
          "<name>$args{list_name}</name>",
        '</filter>',
      '</del-list>',
    '</maillist>',
  );
}

=head1 NAME

Net::Plesk::Method::mail_remove - Perl extension for Plesk XML Remote API mail removal

=head1 SYNOPSIS

  use Net::Plesk::Method::mail_remove

  my $p =
    new Net::Plesk::Method::mail_remove ( $domainID, $mailbox );

  $request = $p->endcode;

=head1 DESCRIPTION

This module implements an interface to construct a request for a mailbox
removal using SWSOFT's Plesk.

=head1 METHODS

=over 4

=item init args ...

Initializes a Plesk mail_remove object.  The I<domainID> and I<mailbox>
options are required.

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

