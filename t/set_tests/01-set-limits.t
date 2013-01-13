# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Data::Dumper;
use Scalar::Util qw/blessed/;
# use Test::More 'no_plan';
use Test::More tests => 13;

use_ok('Net::Plesk');

#########################

use Config::Any;
my @files;
push @files,'plesk.yml';
my $config = Config::Any->load_files({files => \@files, flatten_to_hash => 1, use_ext => 0 });
my $username = $config->{'plesk.yml'}->{username};
my $password = $config->{'plesk.yml'}->{password};
my $hostname = $config->{'plesk.yml'}->{hostname};

my $client_id;

my $plesk = eval { 

  Net::Plesk->new(
    'POST'              => "https://$hostname:8443/enterprise/control/agent.php",
    ':HTTP_AUTH_LOGIN'  => $username,
    ':HTTP_AUTH_PASSWD' => $password,
  );

};

ok(blessed($plesk), 'got a plesk object');

################################################################################
################################################################################

# confirm we'll be setting the right client id

ok(my $client_get_response = $plesk->client_get('mattr'), 'client_get returned response');
ok(my $client_get_results = $client_get_response->results, 'client_get gave results');
  
  $client_id = $client_get_response->id;

if ($client_get_response->errortext) {
    note('returned error for set_limits '.$client_get_results->errortext);  
} else {

ok(
  ref($client_get_results) eq 'ARRAY' && @$client_get_results == 1, 
  'client_get returned array containing one entry',
);

ok(
  ref $client_get_results->[0] eq 'HASH' && (my $client_results = shift @$client_get_results), 
  'client_get returned a hash',
);

ok($client_results->{id} == $client_id, 'client_get returned correct client id');

################################################################################
################################################################################

# set limit for client 

my %args = (
  is_client => 1,
  key       => $client_id,
  limits    => { max_dom => -1 },
);

ok(my $set_limits_response = $plesk->set_limits(%args), 'got response object');

if ($set_limits_response->errortext) {
  note('returned error from setting limits'.$set_limits_response->errortext);

} else { 
ok(my $set_limits_results = $set_limits_response->results, 'set_limits response has results');

ok(
  ref($set_limits_results) eq 'ARRAY' && @$set_limits_results == 1, 
  'set_limits_results are array with one entry',
);

ok(
  ref($set_limits_results->[0]) eq 'HASH' && (my $client_set_results = shift @$set_limits_results), 
  'got a client hash',
);

ok($client_set_results->{status} eq 'ok', 'status ok');
ok($client_set_results->{id} == $client_id, 'confirmed correct client id');

}
}
################################################################################
################################################################################
