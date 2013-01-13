package Net::Plesk::Method::ftp_user_add;

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

  my $username  = $args{ftp_username};
  my $password  = $args{ftp_password};
  my $domain_id = $args{domain_id};

  $$self = join "\n" => (
    '<ftp-user>',
      '<add>',
        $self->element( name        => $username ),
        $self->element( password    => $password ),
        '<home />',
        $self->element( 'domain-id' => $domain_id ),
      '</add>',
    '</ftp-user>',
  );
}

################################################################################
################################################################################

1;
