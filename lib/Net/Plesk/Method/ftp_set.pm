package Net::Plesk::Method::ftp_set;

use strict;
use vars qw( $VERSION $AUTOLOAD $DEBUG );
use parent 'Net::Plesk::Method';
use constant api_version => '1.5.2.1';

$VERSION = '0.01';
$DEBUG   = 0;

sub init {
  my ($self, %args) = @_;

  $$self = join "\n" => (
    '<set>',
       '<filter>',
           "<domain_name>$args{domain_name}</domain_name>",
       '</filter>',
       '<values>',
           '<hosting>',
           '<vrt_hst>',
             "<ip_address>$args{ip_address}</ip_address>",
             '<property>',
               '<name>ftp_login</name>',
               "<value>$args{username}</value>",
             '</property>',
             '<property>',
               '<name>ftp_password</name>',
               "<value>$args{password}</value>",
             '</property>',
           '</vrt_hst>',
           '</hosting>',
       '</values>',
    '</set>',
    '</domain>'
  );

}

=head1 NAME

Net::Plesk::Method::domain_get - Perl extension for Plesk XML Remote API domain 
                         information retreival

=head1 SYNOPSIS

  use Net::Plesk::Method::domain_get

  my $p = new Net::Plesk::Method::domain_get ( 'domain.com' );

=head1 DESCRIPTION

This module implements an interface to construct a request for domain
information retreival using SWSOFT's Plesk.

=head1 METHODS

=over 4

=item init args ...

Initializes a Plesk domain_get object.  The I<domain> option is required.

=cut

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
