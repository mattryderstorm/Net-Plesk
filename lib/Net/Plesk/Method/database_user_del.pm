package Net::Plesk::Method::database_user_del;

use strict;

use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );

@ISA = qw( Net::Plesk::Method );
$VERSION = '0.01';

$DEBUG = 0;

sub api_version { '1.5.2.1' }

sub init {
  my ($self, %args) = @_;

  $$self = join "\n" => (
    '<database>',
      '<del-db-user>',
        '<filter>', 
          $self->make_user_ids(%args),
        '</filter>',
      '</del-db-user>',
    '</database>'
  );
}

sub make_user_ids {
  my ($self, %args) = @_;

  my $user_ids = ref $args{user_ids} ? $args{user_ids} : [ $args{user_ids} ];

  return map { $self->defined_element( id => $_ ) } @$user_ids;
}

=head1 NAME

Net::Plesk::Method::domain_get - Perl extension for Plesk XML Remote API domain 
                         information retreival

=head1 SYNOPSIS

  use Net::Plesk::Method::add_database

  my $p = new Net::Plesk::Method::add_database ( 'domain.com' );

=head1 DESCRIPTION

This module implements an interface to construct a request for domain
information retreival using SWSOFT's Plesk.

=head1 METHODS

=over 4

=item init args ...

Initializes a Plesk domain_get object.  The I<domain> option is required.

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

