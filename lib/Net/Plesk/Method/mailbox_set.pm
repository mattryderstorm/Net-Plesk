package Net::Plesk::Method::mailbox_set;

use strict;
use vars qw( $VERSION $AUTOLOAD $DEBUG );
use constant api_version => '1.5.2.1';
use parent 'Net::Plesk::Method';

$VERSION = '0.01';
$DEBUG   = 0;

sub init {
  my ($self, %args) = @_;

  my $mailbox_enabled  = exists $args{password} ? 'true' : 'false';
  my $redirect_enabled = $args{redirect} ? 'true' : 'false';

  # password OR redirect, not both
  # my $redirect_info = sprintf "<redirect><enabled>%s</enabled>%s</redirect>", $redirect_enabled, $self->defined_element(address => $args{redirect});

  $$self = join "\n" => (
    '<mail>',
      '<update>',
        '<set>',
          '<filter>',
            "<domain_id>$args{domain_id}</domain_id>",
            '<mailname>',

              $self->element(name => $args{username}),
              "<mailbox><enabled>$mailbox_enabled</enabled></mailbox>",
              $self->defined_element(password => $args{password}),
              # $redirect_info,

            '</mailname>',
          '</filter>',
        '</set>',
      '</update>',
    '</mail>',
  );
}

=head1 NAME

Net::Plesk::Method::mail_set - Perl extension for Plesk XML Remote API mailbox setting

=head1 SYNOPSIS

  use Net::Plesk::Method::mail_set

  my $p = new Net::Plesk::Method::mail_set
    ( $domainID, $mailbox, $passwd, $enabled );

  $request = $p->endcode;

=head1 DESCRIPTION

This module implements an interface to construct a request for setting a
mailbox using SWSOFT's Plesk.

=head1 METHODS

=over 4

=item init args ...

Initializes a Plesk mail_set object.  The I<domainID>, I<mailbox>, and
I<password> options are required.

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

