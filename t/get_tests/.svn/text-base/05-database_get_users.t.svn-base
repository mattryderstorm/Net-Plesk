# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Data::Dumper;
use Test::More tests => 8;
use Scalar::Util qw/blessed/;
use YAML();
use_ok('Net::Plesk');

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

my $response;

my $legit = {
  'filter-id' => '58',
  'status' => 'ok',
  'id' => '1',
  'login' => 'testuser',
};

ok(my $r = $plesk->domain_get('testdistributeit.com.au'), 'got a response object for domain_get ');

if ($r->errortext) {
    note('returned error'.$r->errortext);
} else {
    ok($response = $plesk->database_get($r->id), 'got a response object for database_get');
    ok(blessed($response), 'response object is blessed');

    if ($response->errortext) { 
        note('returned error'.$response->errortext);
    } else {

        if (defined($response->results->[0]->{'id'})) {
          ok($response = $plesk->database_get_users($response->id),'got a response object for database_get_users ');
          ok(blessed($response), 'response object is blessed');
          if ($response->errortext) {
            note('returned error'.$response->errortext);
          } else {
            $legit->{'filter-id'} = $response->results->[0]->{'filter-id'};
            $legit->{'id'} = $response->results->[0]->{'id'};
            $legit->{'db-id'} = $response->results->[0]->{'db-id'};
            $legit->{'login'} = $response->results->[0]->{'login'};
            is_deeply($response->results->[0], $legit, 'database_get_users matches test data');
          }
        } else {
            note('no databases are defined');
        }
    }
}
