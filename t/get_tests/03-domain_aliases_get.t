# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Data::Dumper;
use Test::More tests => 6;
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
my $legit = {
           'info' => {
                     'manage-dns' => 'true',
                     'domain_id' => '14',
                     'status' => '0',
                     'pref' => {
                               'web' => 'true',
                               'tomcat' => 'false',
                               'mail' => 'true'
                             }
                   },
           'status' => 'ok',
         };

ok(blessed($plesk), 'got a plesk object');

ok($response = $plesk->domain_get('testdistributeit.com.au'), 'got a response object');
ok(blessed($response), 'response object is blessed');
my $domainID = $response->id;
ok($response = $plesk->domain_alias_retrieve($domainID), 'got a response object');

$legit->{'info'}->{'ascii-name'} = $response->results->[0]->{'info'}->{'ascii-name'};
$legit->{'info'}->{'name'} = $response->results->[0]->{'info'}->{'name'};
$legit->{'info'}->{'domain_id'} =  $domainID;

$legit->{'filter-id'} =  $domainID;
$legit->{'id'} = $response->results->[0]->{'id'};

is_deeply($response->results, $legit, 'got legit results from domain_alias_get');

