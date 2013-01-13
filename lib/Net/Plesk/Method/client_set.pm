package Net::Plesk::Method::client_set;

use strict;

use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );
use XML::Simple;
use Data::Dumper;

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
sub api_version { '1.5.2.1' }

sub init {
  my ($self, %args) = @_;

  my @fields = qw/cname pname passwd phone fax email address city state pcode country locale/;

  my $encoded_fields = join "", map { $self->defined_element($_, $args->{$_}) } @fields;

  my $client_filter = $self->client_filter(\%args);

  my $xml = qq{
    <client>
      <set>
        <filter>$client_filter</filter>
        <gen_info />
      </set>
    </client>
  };

  $$self = $xml;
}

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

