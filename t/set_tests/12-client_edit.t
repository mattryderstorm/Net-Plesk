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

ok (my $response_client = $plesk->client_get('mattr'),'get client successfully');
if ($response_client->errortext) {
    note('returned error'.$response_client->errortext);
} else {
$id = $response_client->id;

  my %args;
  $args{is_client} = 1;
  $args{key} = $id; 
  
  $args{cname} = 'testname';
  $args{pname} = 'testcoco';

  ok($client_edit = $plesk->client_edit(%args),'edited new_client');
  if ($client_edit->errortext) {
      note('returned error');
      note('Error Message'.$client_edit->errortext);
  } else {
    $id = $client_edit->results->[0]->{'id'};

    $legit->{'id'} = $client_edit->results->[0]->{'id'};
    $legit->{'filter-id'} = $client_edit->results->[0]->{'filter-id'};

    ok(blessed($client_edit), 'response object is blessed');
    is_deeply($client_edit->results, $legit, 'client_edi tmatches test data');
  }
}
