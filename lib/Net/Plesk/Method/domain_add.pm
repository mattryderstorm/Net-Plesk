package Net::Plesk::Method::domain_add;

use strict;

use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );

@ISA = qw( Net::Plesk::Method );
$VERSION = '0.02';

$DEBUG = 0;

sub api_version { '1.4.2.0' }

sub init {
  my ($self, %args) = @_;

  my @hosting_type  = $args{username} ? '<htype>vrt_hst</htype>' : ();
  my @template_name = $args{template} ? "<template-name>$args{template}</template-name>" : ();

  my @hosting_cfg;

  if (@hosting_type) {
    push @hosting_cfg => (
      '<hosting>',
        '<vrt_hst>',

            "<ftp_login>$args{username}</ftp_login>",
            "<ftp_password>$args{password}</ftp_password>",

            $self->element(ssl => $args{os} eq 'linux' ? 'true' : 'false'),
            "<shell-forbidden/>",
            $self->_get_os_config(%args),

          "<ip_address>$args{ip_address}</ip_address>",
        '</vrt_hst>',
      '</hosting>',
    );
  }

  my @domain_add = (
    '<domain>',
      '<add>',
        '<gen_setup>',
          "<name>$args{domain}</name>",
          "<client_id>$args{client_id}</client_id>",
          "<ip_address>$args{ip_address}</ip_address>",
          @hosting_type,
        '</gen_setup>',
        @hosting_cfg,
        @args{username} ? '<prefs><www>true</www></prefs>' : (),
        @template_name,
      '</add>',
    '</domain>',
  );

  $$self = join "\n" => @domain_add;
}

sub _get_os_config {
  my ($self, %args) = @_;

  my @hosting_config = @{ $args{hosting_config} };

  my @xml;

  while (my ($key, $value) = splice(@hosting_config, 0, 2)) {
    push @xml, $self->defined_element($key, $value);
  }

  return join "\n", @xml;
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

