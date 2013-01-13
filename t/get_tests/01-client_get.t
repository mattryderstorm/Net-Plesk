# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Data::Dumper;
use Test::More tests => 5;
use Scalar::Util qw/blessed/;

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

my $legit = {
           'filter-id' => 'mattr',
           'status' => 'ok',
           'data' => {
                     'sbnet-user' => 'false',
                     'gen_info' => {
                                   'status' => '0',
                                   'cr_date' => '2009-03-31',
                                   'locale' => {},
                                   'state' => 'FAKE STATE',
                                   'cname' => 'testname',
                                   'email' => 'mattr@distributeit.com.au',
                                   'password' => 'fishfood14',
                                   'city' => 'faker city',
                                   'fax' => '72364872234',
                                   'guid' => '9cbbd810-32cb-4627-a2bb-28e24816a632',
                                   'address' => '14 fake street',
                                   'country' => 'AU',
                                   'password_type' => 'plain',
                                   'phone' => '89573972342',
                                   'pcode' => '8474',
                                   'login' => 'mattr',
                                   'pname' => 'testcoco'
                                 }
                   },
           'id' => '19'
};

my $response;

ok($response = $plesk->client_get('mattr'), 'got a response object');
ok(blessed($response), 'response object is blessed');
if ($response->errortext) {
   note('returned error from client_get '.$response->errortext);
} else {
    $legit->{'id'} = $response->results->[0]->{'id'};
    $legit->{'data'}->{'gen_info'}->{'guid'} = $response->results->[0]->{'data'}->{'gen_info'}->{'guid'};
    $legit->{'data'}->{'gen_info'}->{'cr_date'} = $response->results->[0]->{'data'}->{'gen_info'}->{'cr_date'};
    is_deeply($response->results, $legit, 'client_get matches test data');
}
