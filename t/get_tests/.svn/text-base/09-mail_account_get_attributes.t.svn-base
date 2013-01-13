# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Data::Dumper;
use Test::More tests => 7;
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

my ($response_mail,$response_domain,$response_mail_account);

my $legit = {
          'status' => 'ok',
          'mailname' => {
                        'permissions' => {
                                         'permission' => {
                                                         'manage_virusfilter' => {
                                                                                 'value' => 'false'
                                                                               },
                                                         'manage_spamfilter' => {
                                                                                'value' => 'false'
                                                                              },
                                                         'cp_access' => {
                                                                        'value' => 'true'
                                                                      }
                                                       }
                                       },
                        'password_type' => 'plain',
                        'name' => 'testuser3',
                        'password' => 'test123',
                        'redirect' => {
                                      'enabled' => 'true',
                                      'address' => 'test@distributeit.com.au',
                                    },
                        'antivir' => 'off',
                        'id' => '29',
                        'mailbox' => {
                                     'quota' => '-1',
                                     'enabled' => 'true'
                                   }
                      }
};

ok($response_domain = $plesk->domain_get('testdistributeit.com.au'), 'got a response object');
ok(blessed($response_domain), 'response object is blessed');
ok($response_mail = $plesk->mail_get($response_domain->id), 'got a response object');
$legit->{'mailname'}->{'id'} = $response_mail->results->[0]->{'mailname'}->{'id'};
ok($response_mail_account = $plesk->mail_get_account_attributes($response_domain->id,$response_mail->results->[0]->{'mailname'}->{'name'}), 'got a response object');
is_deeply($response_mail_account->results, $legit, 'mail_get_account_attributes matches test data');

