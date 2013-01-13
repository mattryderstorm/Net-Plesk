package Net::Plesk::Method::domain_set;

use strict;

use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );

@ISA = qw( Net::Plesk::Method );
$VERSION = '0.02';

$DEBUG = 0;

sub api_version { '1.4.2.0' }

################################################################################
################################################################################

sub init {
  my ($self, %args) = @_;

  my @values = $self->_get_values(%args);

  $$self = join "\n" => (
    '<domain>',
      '<set>',
        '<filter>',
          "<domain_name>$args{domain_name}</domain_name>",
        '</filter>',
        @values,
      '</set>',
    '</domain>',
  );
}

################################################################################
################################################################################

sub _get_values {
  my ($self, %args) = @_;

  my @values;

  my @user_values = $self->_get_user_values(%args);
  push( @values, '<user>', @user_values, '</user>' ) if @user_values;

  my @gen_setup = $self->_get_gen_setup(%args);
  push( @values, '<gen_setup>', @gen_setup, '</gen_setup>' ) if @gen_setup;

  return '<values>', @values, '</values>';
}

################################################################################
################################################################################

sub _get_user_values {
  my ($self, %args) = @_;

  return unless my $user_values = $args{user_values};
  return unless keys %$user_values;

  my %remap = (
    active   => 'enabled',
    postcode => 'pcode',
  );

  my @user_values;

  foreach my $key (qw/pname phone fax email address city state country perms/) {
    push @user_values, $self->defined_element( $key, $user_values->{$key} );
  }

  while (my ($src, $key) = each %remap) {
    push @user_values, $self->defined_element( $key, $user_values->{$src} );
  }

  return @user_values;
}

################################################################################
################################################################################

sub _get_gen_setup {
  my ($self, %args) = @_;

  return unless ref( my $gen = $args{gen_setup} );
  return unless keys %$gen;

  my @gen_setup;

  foreach my $key (qw/status client_id name ip_address/) {
    push @gen_setup, $self->defined_element( $key, $gen->{$key} );
  }

  return @gen_setup;
}

################################################################################
################################################################################

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

