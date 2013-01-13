package Net::Plesk::Method::client_get;

use strict;

use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );

@ISA = qw( Net::Plesk::Method );
$VERSION = '0.01';

$DEBUG = 0;

=head1 NAME

Net::Plesk::Method::client_get - Perl extension for Plesk XML Remote API client
                         retrieval

=head1 SYNOPSIS

  use Net::Plesk::Method::client_get

  my $p = new Net::Plesk::Method::client_get ( $login );

  $request = $p->endcode;

=head1 DESCRIPTION

This module implements an interface to construct a request for a client
retrieval using SWSOFT's Plesk.

=head1 METHODS

=over 4

=item init args ...

Initializes a Plesk client_get object.  The I<login> options is required.

=cut

sub api_version { '1.5.2.0' }

sub init {
  my ($self, %args) = @_;

  my %filter_keys = (
    client_id => 'id',
    username  => 'login',
    pname     => 'pname',
  );

  my ($arg_key) = grep { $args{$_} } keys %filter_keys;
  die 'missing filter key' unless $arg_key;

  my $filter_key   = $filter_keys{$arg_key};
  my $filter_value = $args{$arg_key};
  die "missing filter value" unless $filter_value;
  
  $$self = join "\n" => (
	  '<client>',
      '<get>',
        '<filter>',
          "<$filter_key>$filter_value</$filter_key>",
        '</filter>',
        '<dataset>', 
          '<gen_info />', 
          '<stat />', 
          '<permissions />', 
          '<limits />', 
          '<ippool />', 
        '</dataset>',
      '</get>',
    '</client>',
  );
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

