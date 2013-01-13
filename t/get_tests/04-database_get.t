# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use YAML;
use Data::Dumper;
use Test::More tests => 5;
use Scalar::Util qw/blessed/;
use_ok('Net::Plesk');
use Config::Any;
my @files;
push @files,'plesk.yml';
my $config = Config::Any->load_files({files => \@files, flatten_to_hash => 1, use_ext => 0 });
my $username = $config->{'plesk.yml'}->{username};
my $password = $config->{'plesk.yml'}->{password};
my $hostname = $config->{'plesk.yml'}->{hostname};

my $plesk = eval { 

  Net::Plesk->new(
    'POST'              => "https://$hostname:8443/enterprise/control/agent.php",
    ':HTTP_AUTH_LOGIN'  => $username,
    ':HTTP_AUTH_PASSWD' => $password,
  );

};

ok(blessed($plesk), 'got a plesk object');
my $legit = {
  'status' => 'ok',
  'db-server-id' => '1',
  'default-user-id' => '0',
  'type' => 'mysql',
};

my $response;

ok(my $r = $plesk->domain_get('testdistributeit.com.au'), 'got a response object');
if ($r->errortext) {
    note('returned error'.$r->errortext);
} else {
  ok($response = $plesk->database_get($r->id), 'got a response object');
  if ($response->errortext) {
    note('returned error '.$response->errortext);
  } else {
    $legit->{'filter-id'} = $r->id;
    $legit->{'name'} = $response->results->[0]->{'name'};
    $legit->{'id'} =   $response->results->[0]->{'id'};
    $legit->{'domain-id'} =   $r->id;
    is_deeply($response->results->[0], $legit, 'database_get matches test data');
  }
}

