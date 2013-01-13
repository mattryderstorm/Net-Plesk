package Net::Plesk::Method::server_ip_get;

use strict;
use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );

@ISA = qw( Net::Plesk::Method );
$VERSION = '0.01';
$DEBUG = 0;

sub api_version { '1.4.2.0' }

sub init {
  my ($self) = @_;

  $$self = join "\n" => (
    '<ip>',
      '<get />',
    '</ip>',
  );
}

1;
