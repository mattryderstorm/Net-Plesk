# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Data::Dumper;
use Test::More tests => 7;
use Scalar::Util qw/blessed/;
use Regexp::Common qw /number/;
use_ok('Net::Plesk');
use YAML();
#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.
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
  'id' => '',
};


ok($response_domain = $plesk->domain_get('testdistributeit.com.au'), 'got a response object');

if ($response_domain->errortext) {
    note('returned error '.$response_domain->errortext);
} else {
  ok(blessed($response_domain), 'response object is blessed');
  ok($response_db_server = $plesk->retrieve_db_server('mysql'),'got a response object');
  if ($response_db_server->errortext) {

  } else {
    ok($response_database = $plesk->database_add($response_domain->id,'testdb','mysql',$response_db_server->id,'linux'), 'got a response object');
    if ($response_database->errortext) {
        note('returned error'.$response_database->errortext);
    } else {
        $legit->{'id'} = $response_database->results->[0]->{'id'};
        is_deeply($response_database->results, $legit, 'database_add matches test data');
    }
  }
} 

