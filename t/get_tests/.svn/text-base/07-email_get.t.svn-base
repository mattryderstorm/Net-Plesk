# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Data::Dumper;
use Test::More tests => 6;
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
          'status' => 'ok',
          'mailname' => {
                        'password' => 'test123',
                        'password_type' => 'plain',
                        'antivir' => 'off',
                        'name' => 'testuser3',
                      }
};
ok($response = $plesk->domain_get('testdistributeit.com.au'), 'got a response object');
ok(blessed($response), 'response object is blessed');
if ($response->errortext) {
  note('returned error'.$response->errortext);
} else {
  
  ok($response = $plesk->mail_get($response->id), 'got a response object');
  $legit->{'mailname'}->{'id'} = $response->results->[0]->{'mailname'}->{'id'};
  is_deeply($response->results->[0], $legit, 'email_get matches test data');
}
