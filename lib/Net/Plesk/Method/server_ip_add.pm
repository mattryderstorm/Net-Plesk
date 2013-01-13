package Net::Plesk::Method::server_ip_add;

use strict;
use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );
use constant api_version => '1.4.2.0';

@ISA     = qw( Net::Plesk::Method );
$VERSION = '0.01';
$DEBUG   = 0;

sub init {
  my ($self, %args) = @_;

  $$self = join "\n" => (
    '<ip>',
      '<add>',
        "<ip_address>$args{ip_address}</ip_address>",
        "<netmask>$args{netmask}</netmask>",
        "<type>$args{type}</type>",
        "<interface>$args{interface}</interface>",
      '</add>',
    '</ip>',
  );
}

1;
