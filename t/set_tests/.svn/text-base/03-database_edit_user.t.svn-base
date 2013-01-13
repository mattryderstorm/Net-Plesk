# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Data::Dumper;
use Test::More tests => 8;
use Scalar::Util qw/blessed/;
use Regexp::Common qw /number/;
use_ok('Net::Plesk');
use YAML();

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.
use Config::Any;

my @files;
push @files,'plesk.yml';

$config = Config::Any->load_files({files => \@files, flatten_to_hash => 1, use_ext => 0 });
my $username = $config->{'plesk.yml'}->{username};
my $password = $config->{'plesk.yml'}->{password};
my $hostname = $config->{'plesk.yml'}->{hostname};

my @db_ids;
my $legit = {
          'status' => 'ok',
        };

my $plesk = eval { 

  Net::Plesk->new(
    'POST'              => "https://$hostname:8443/enterprise/control/agent.php",
    ':HTTP_AUTH_LOGIN'  => $username,
    ':HTTP_AUTH_PASSWD' => $password,
  );

};

ok(blessed($plesk), 'got a plesk object');

ok($response_domain = $plesk->domain_get('testdistributeit.com.au'), 'got a response object');
ok(blessed($response_domain), 'response object is blessed');
ok($response_database_get = $plesk->database_get($response_domain->id),'database object');
my $db_id = $response_database_get->results->[0]->{'id'};
ok($response_database_users_get = $plesk->database_get_users($db_id),'database users object');
my $db_user_id = $response_database_users_get->results->[0]->{'id'};
my $db_password = $response_database_users_get->results->[0]->{'password'};

my $db_users = {
  id => $db_user_id,
  password => 'mootman',
};

ok($response_database_set_password = $plesk->database_set_users($db_users),'database user update');
is_deeply($response_database_set_password->results, $legit, 'database_del matches test data');




