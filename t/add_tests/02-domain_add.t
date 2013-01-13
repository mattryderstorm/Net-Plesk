# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Data::Dumper;
use Test::More tests => 6;
use Scalar::Util qw/blessed/;
use Config::Any;
use_ok('Net::Plesk');

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
$ip = "114.31.73.30";
$user = "testmattr";
$pass = "night1543";
$template = "";
my $legit = {
    'status' => 'ok',
};

ok(blessed($plesk), 'got a plesk object');

my $response;
ok($client_get = $plesk->client_get('mattr'),'retrieved client');
ok(blessed($client_get), 'response object is blessed');

ok($domain_add = $plesk->domain_add('testdistributeit.com.au',$client_get->id,$ip,$template,$user,$pass),'domain record successfully added');
if ($domain_add->errortext) {
  note('returned error');
  note('Message: '.$domain_add->errortext);
} else {
  $legit->{'id'} = $domain_add->results->[0]->{'id'};
  is_deeply($domain_add->results, $legit, 'client_get matches test data');
}

