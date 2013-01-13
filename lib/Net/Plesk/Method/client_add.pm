package Net::Plesk::Method::client_add;

use strict;

use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );

@ISA = qw ( Net::Plesk::Method );
$VERSION = '0.01';

$DEBUG = 0;

=head1 NAME

Net::Plesk::Method::client_add - Perl extension for Plesk XML Remote API client addition

=head1 SYNOPSIS

  use Net::Plesk::Method::client_add

  my $p = new Net::Plesk::client_add ( $clientID, 'client.com' );

=head1 DESCRIPTION

This module implements an interface to construct a request for a client
addition using SWSOFT's Plesk.

=head1 METHODS

=over 4

=item init args ...

Initializes a Plesk client_add object.  The I<login> and I<password>
options are required.

=cut

sub api_version { '1.4.2.0' }

################################################################################
################################################################################

sub init {
  my ($self, %args) = @_;

  my @info_keys = qw/pname cname login passwd phone fax email address city state pcode country/;

  $args{$_} && ($args{$_} = $self->encode($args{$_})) for @info_keys;
  $args{$_} && ($args{$_} = "<$_>$args{$_}</$_>")     for @info_keys;

  my $gen_info = join "\n", grep { defined } @args{@info_keys};

  my $perms = $self->_prepare_permissions(%args);
  my $limits = $self->_prepare_limits(%args);
  my @sbnet_user = $self->_prepare_sbnet_user(%args);

  $$self = join "\n" => (
    '<client>',
      '<add>',

        '<gen_info>',    $gen_info,  '</gen_info>', 
        '<limits>',      $limits,    '</limits>',
        '<permissions>', $perms,     '</permissions>', 
        @sbnet_user,

	    '</add>',
	  '</client>',
    );
}

################################################################################
################################################################################

sub _prepare_permissions {
  my ($self, %args) = @_;

  my @permissions = @{ $args{permissions} };

  my @xml;

  while (my ($key, $value) = splice(@permissions, 0, 2)) {
    push @xml, $self->defined_element($key, $value);
  }

  return join "\n", @xml;
}

################################################################################
################################################################################

sub _prepare_limits {
  my ($self, %args) = @_;

  my @limits = @{ $args{limits} };

  my @xml;

  while (my ($key, $value) = splice(@limits, 0, 2)) {
    push @xml, $self->defined_element($key, $value);
  }

  return join "\n", @xml;
}

################################################################################
################################################################################

sub _prepare_sbnet_user {
  my ($self, %args) = @_;

  return unless my $sbnet = $args{sbnet};

  return '<sbnet-user>true</sbnet-user>';
}

################################################################################
################################################################################

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

