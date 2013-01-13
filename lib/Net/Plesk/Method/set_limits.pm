package Net::Plesk::Method::set_limits;

use strict;
use vars qw( $VERSION @ISA $AUTOLOAD $DEBUG );
use constant api_version => '1.4.2.0';
use parent 'Net::Plesk::Method';

$VERSION = '0.01';
$DEBUG   = 0;

sub init {
  my ($self, %args) = @_;

  my $x = XML::Simple->new(NoAttr => 1);

  my $encode = sub {
    my $k = shift;
    my $v = shift;

    return $x->XMLout( $v, RootName => $k, @_ );
  };

  my $is_client    = int( $args{is_client} );
  my $filter_type  = $is_client ? 'id' : 'domain_name';

  my $filterData   = $encode->( $filter_type, $args{key} );
  my $filter       = $encode->( filter => $filterData, NoEscape => 1 );

  my $limits       = $encode->( limits => $args{limits}, RootName => 'limits' );
  my $values       = $encode->( values => $limits, NoEscape => 1 );

  my $set          = $encode->( set => $filter . $values, NoEscape => 1 );
  my $account_type = $is_client ? 'client' : 'domain';

  $$self = $encode->( $account_type => $set, NoEscape => 1 );
}

1;
