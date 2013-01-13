# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Data::Dumper;
use Test::More tests => 6;
use Scalar::Util qw/blessed/;

use_ok('Net::Plesk');
use Config::Any;
#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

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

my $response;

my $legit = {
  'status' => 'ok', 
};
ok($client_get = $plesk->client_get('mattr'),'retrieved client');

if ($client_get->errortext) {
  note('returned error'.$client_get->errortext);
} else {
  ok($client_del = $plesk->client_delete($client_get->id),'deleted client');
  if ($client_del->errortext) {
      note('returned error '.$client_del->errortext);
  } else {
    $id = $client_del->results->[0]->{'id'};
    $legit->{'id'} = $id;
    ok(blessed($client_del), 'response object is blessed');
    is_deeply($client_del->results->[0], $legit, 'client_delete matches test data');
  }
}
