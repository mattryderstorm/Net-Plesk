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

my @db_ids;
my $legit = {
          'filter-id' => '',
          'status' => 'ok',
          'id' => '',
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
if ($response_domain->errortext) {

} else {
ok($response_database_get = $plesk->database_get($response_domain->id),'database object');
  if ($response_database_get->errortext) {
    note('returned error');
    note('Message: '.$response_database_get->errortext);
  } else {
    my $db_del_id = $response_database_get->results->[0]->{'id'};
    $legit->{'id'} = $db_del_id;
    $legit->{'filter-id'} = $db_del_id; 
    push @db_ids,$db_del_id;
    ok($response_database_del = $plesk->database_del(\@db_ids),'database object');
    if ($response_database_del->errortext) {
      note('returned error');
      note('Message: '.$response_database_del->errortext);
    } else {
      is_deeply($response_database_del->results, $legit, 'database_del matches test data');
    }
  }
}


