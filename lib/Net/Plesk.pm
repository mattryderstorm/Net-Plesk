package Net::Plesk;

use 5.005;
use strict;

use vars qw( $VERSION @ISA $AUTOLOAD $PROTO_VERSION $POST_URL
             @EXPORT_OK %EXPORT_TAGS ); # @EXPORT

use Exporter;
use LWP;
use Data::Dumper;
use XML::Simple;

use Net::Plesk::Response;
use Net::Plesk::Method;

@ISA = qw(Exporter);

$VERSION = '0.03';

BEGIN {
  use constant NET_PLESK_DEBUG => $ENV{NET_PLESK_DEBUG};
  warn "\$ENV{NET_PLESK_DEBUG} is: $ENV{NET_PLESK_DEBUG}";
}

my $ua = LWP::UserAgent->new;
$ua->agent("Net::Plesk/$VERSION");

=head1 NAME

Net::Plesk - Perl extension for Plesk XML Remote API

=head1 SYNOPSIS

  use Net::Plesk;

  my $plesk = new Net::Plesk (
    'POST'      => 'https://plesk.sample.com:8443/enterprise/control/agent.php',
    ':HTTP_AUTH_LOGIN' => '1357948',
    ':HTTP_AUTH_PASSWD' => 'password',
  );

  # client_get

  my $clientname = 'tofu_beast';
  my $response = $plesk->client_get( $clientname );
  die $response->errortext unless $response->is_success;
  my $clientID = $response->id;

  # client_add

  unless $clientID {
    my $clientname = 'Tofu Beast';
    my $login      = 'tofu_beast';
    my $password   = 'manyninjas';
    my $response = $plesk->client_add( $clientname,
                                       $login,
				       $password,
				       $phone,
				       $fax,
				       $email,
				       $address,
				       $city,
				       $state,
				       $postcode,
				       $country,
	                              );
    die $response->errortext unless $response->is_success;
    $clientID = $response->id;
    print "$clientname created with ID $clientID\n";
  }

  # client_ippool_add_ip

  my $ipaddress = '192.168.8.45';
  my $response = $plesk->client_ippool_add_ip( $clientID, $ipaddress );
  die $response->errortext unless $response->is_success;

  # domain_get

  my $domain = 'basilisk.jp';
  my $response = $plesk->domain_get( $domain );
  die $response->errortext unless $response->is_success;
  my $domainID = $response->id;

  # domain_add

  my $domain = 'basilisk.jp';
  my $clientID = 17;
  my $ipaddr = '192.168.8.45';
  my $response = $plesk->domain_add( $domain, $clientID, $ipaddr );
  die $response->errortext unless $response->is_success;
  my $domainID = $response->id;

  # domain_del

  my $domain = 'basilisk.jp';
  my $response = $plesk->domain_add( $domain );
  die $response->errortext unless $response->is_success;

  # mail_add 

  my $username = 'tofu_beast';
  my $response = $plesk->mail_add( $domainID, $username, 'password' );
  die $response->errortext unless $response->is_success;
  my $uid = $response->id;
  print "$username created: uid $uid\n";

  # mail_remove

  $response = $plesk->mail_remove( 'username' );
  if ( $response->is_success ) {
    print "mailbox removed";
  } else {
    print "error removing mailbox: ". $response->errortext;
  }

  # mail_set

  my $enabled = ($user_balance <= 0);
  $response = $plesk->mail_set( $domainID, 'username', 'password', $enabled );
  die $response->errortext unless $response->is_success;

=head1 DESCRIPTION

This module implements a client interface to SWSOFT's Plesk Remote API,
enabling a perl application to talk to a Plesk managed server.
This documentation assumes that you are familiar with the Plesk documentation
available from SWSOFT (API 1.4.0.0 or later).

A new Net::Plesk object must be created with the I<new> method.  Once this has
been done, all Plesk commands are accessed via method calls on the object.

=head1 METHODS

=over 4

=item new OPTION => VALUE ...

Creates a new Net::Plesk object.  The I<URL>, I<:HTTP_AUTH_LOGIN>, and
I<:HTTP_AUTH_PASSWD> options are required.

=cut

sub new {
  my ($proto, @args) = @_;
  my $class = ref($proto) || $proto;

  my $self = { @args };

  bless($self, $class);
}

=item AUTOLOADed methods

Not all Plesk methods are available.  See the Plesk documentation for methods,
arguments and return values.  See B<Net::Plesk::Method> for available methods.

Responses are returned as B<Net::Plesk::Response> objects.  See
L<Net::Plesk::Response>.

=cut

sub AUTOLOAD {

  my $self = shift;
  $AUTOLOAD =~ s/.*:://;
  return if $AUTOLOAD eq 'DESTROY';

  $AUTOLOAD =~ /^([[:alpha:]_]\w*)$/;
  die "$AUTOLOAD Illegal method: $1" unless $1;
  my $autoload = "Net::Plesk::Method::$1";

  die "Couldn't load $AUTOLOAD [$@]" unless do {
    local $@;
    eval "use $autoload; 1";
  };

  #inherit?
  my $req = HTTP::Request->new('POST' => $self->{'POST'});
  $req->content_type('text/xml');

  for (keys(%$self)) { 
    next if $_ eq 'POST';
    $req->header( $_ => $self->{$_} );
  }

  # NET_PLESK_DEBUG and warn __PACKAGE__.'#'.__LINE__.": " . Data::Dumper->new([ \@_ ] => [ '*AUTOLOAD_ARGS' ])->Dump;
  NET_PLESK_DEBUG and $self->_log( Data::Dumper->new([ \@_ ] => [ '*AUTOLOAD_ARGS' ])->Dump );

  my $packet  = $autoload->new(@_);
  my $version = $packet->api_version;
  my $header  = q{<?xml version="1.0"?>};
  my $payload = qq{<packet version="$version">$$packet</packet>};

  $req->content($header . $payload);

  # NET_PLESK_DEBUG and warn $req->as_string. "\n";
  NET_PLESK_DEBUG and $self->_log( $req->as_string. "\n" );

  my $res = $ua->request($req);

  # NET_PLESK_DEBUG and warn "\n\$res->decoded_content:\n". $res->decoded_content;
  NET_PLESK_DEBUG and $self->_log( "\n\$res->decoded_content:\n". $res->decoded_content );

  # Check the outcome of the response
  if ($res->is_success) {

    my $response = Net::Plesk::Response->new( $res->content );
    
    # NET_PLESK_DEBUG and warn __PACKAGE__.'#'.__LINE__.": " . Data::Dumper->new([ $response ] => [ 'response' ])->Dump;
    NET_PLESK_DEBUG and $self->_log( Data::Dumper->new([ $response ] => [ 'response' ])->Dump );

    return $response;
  }
  else {
    return Net::Plesk::Response->new(
      '<?xml version="1.0" encoding="UTF-8"?>'. #a lie?  probably safe
      '<packet version="' . $self->{'version'} . '">' .
      "<system><status>error</status><errcode>500</errcode>" .
      "<errtext>" . $res->status_line . "</errtext></system>" .
      "</packet>"
    );
  }

}

sub _log {
  my ($self, $message) = @_;

  require POSIX;

  my $filename = NET_PLESK_DEBUG() || "plesk_rpc.log";

  my $fh = IO::File->new($filename => 'a');

  $fh->autoflush(1);

  my $now = POSIX::strftime('%F %T', localtime);

  $fh->print("[$now] $message\n");
}

=back

=head1 BUGS

 Multiple request packets not tested. 

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

