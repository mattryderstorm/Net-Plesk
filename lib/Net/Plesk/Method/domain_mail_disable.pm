package Net::Plesk::Method::domain_mail_disable;

use strict;
use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );

@ISA = qw( Net::Plesk::Method );
$VERSION = '0.01';
$DEBUG = 0;

sub api_version { '1.4.2.0' }

sub init {
  my ($self, %args) = @_;

  $$self = join "\n" => (
    '<mail>',
      '<disable>',
        "<domain_id>$args{domain_id}</domain_id>",
      '</disable>',
    '</mail>',
  );
}

1;
