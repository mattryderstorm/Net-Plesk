# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Data::Dumper;
use Test::More tests => 8;
use Scalar::Util qw/blessed/;

use_ok('Net::Plesk');
use Config::Any;
#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

my @files;
push @files,'plesk.yml';
my $config = Config::Any->load_files({files => \@files, flatten_to_hash => 1, use_ext => 0 });

my $username = $config->{'plesk.yml'}->{username} or die "missing username";
my $password = $config->{'plesk.yml'}->{password} or die "missing password";
my $hostname = $config->{'plesk.yml'}->{hostname} or die "missing hostname";

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

my %login = (
  pname   => 'matthew ryder',
  cname   => 'matthew ryder inc',
  login   => 'mattr',
  passwd  => 'fishfood14',
  phone   => '89573972342',
  fax     => '72364872234',
  email   => 'mattr@distributeit.com.au',
  address => '14 fake street',
  city    => 'faker city',
  state   => 'fake state',
  pcode   => '8474',
  country => 'AU',
);

ok(($client_add = $plesk->client_add(%login)), 'added_new_client');
$id = $client_add->results->[0]->{'id'};
$legit->{'id'} = $id;
ok(blessed($client_add), 'response object is blessed');
if ($client_add->errortext) {
  warn('returned error');
  warn('Message: '.$client_add->errortext);
} else {
  is_deeply($client_add->results, $legit, 'client_add matches test data');
  ok($client_ip_add = $plesk->client_ippool_add_ip($id,'114.31.73.30'),'client add ip pool successful');
  ok(not $client_ip_add->errortext);
  $legit = {
        'status' => 'ok',
        'ip_address' => '114.31.73.30'
      };

  is_deeply($client_ip_add->results->[0], $legit, 'client_add matches test data');
}
