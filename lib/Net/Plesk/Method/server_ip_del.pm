package Net::Plesk::Method::server_ip_del;

use strict;
use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );

@ISA = qw( Net::Plesk::Method );
$VERSION = '0.01';
$DEBUG = 0;

sub api_version { '1.4.2.0' }

sub init {
  my ($self, %args) = @_;

  $$self = join "\n" => (
    '<ip>',
      '<del>',
        '<filter>',
          "<ip_address>$args{ip}</ip_address>",
        '</filter>',
      '</del>',
    '</ip>',
  );
}

# sub init {
#   my ($self, $ipaddress,$netmask,$type,$interface) = @_;
#   $$self = join ( "\n", (
# 	            '<ip>',
# 	            '<delete>',
# 	            '<ip_address>',
# 	            $self->encode($ipaddress),
# 	            '</ip_address>',
#               '<netmask>',
#               $self->encode($netmask),
#               '</netmask>',
#               '<type>',
#               $self->encode($type),
#               '</type>',
#               '<interface>',
#               $self->encode($interface),
#               '<interface>',
#               '</filter>',
#               '</delete>'
#               '<ip>'));
# }

1;
