# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Data::Dumper;
use Test::More tests => 19;
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
my $domainID = $response_domain->id;
ok(my $response_mail_get = $plesk->mail_get($response_domain->id),'mail object');

my $redirect_email = 'maxman@blahdistributeit.com.au';
my $password_mail = "test123";
my $login = "testuser3";
$legit = {
    'status' => 'ok',
    'mailname' => {
        'name' => 'testuser3',
    },
};
foreach my $mail_settings (qw/mailbox mailbox_redirect redirect/) {
      
      if ($mail_settings eq 'mailbox') {
          ok($mail_set = $plesk->mail_set($domainID,$login,"true",$password_mail),'mail_set successful');
          $redirect_email = 'test@distributeit.com.au';
          ok($mail_redirect = $plesk->mail_redirect($domainID,$login,"false",$redirect_email),'mail redirect unset successful');
          ok($mail_redirect = $plesk->mail_redirect($domainID,$login,"false",''),'mail redirect unset successful');
          is_deeply($mail_redirect->results,$legit,'mailbox matches test data');
      }
      if ($mail_settings eq 'mailbox_redirect') {
          ok($mail_set = $plesk->mail_set($domainID,$login,"true",$password_mail),'mail set successful');
          ok($mail_redirect = $plesk->mail_redirect($domainID,$login,"true",$redirect_email),'mail redirect set successful');
          is_deeply($mail_redirect->results,$legit,'mail redirect and mailbox matches test data');
      }

      if ($mail_settings eq 'redirect') {
          ok($mail_set = $plesk->mail_set($domainID,$login,"false",$password_mail),'mail unset successful');
          ok($mail_redirect = $plesk->mail_redirect($domainID,$login,"true",$redirect_email),' mail redirect successful');
          is_deeply($mail_redirect->results,$legit,'mail redirect matches test data');
      }
}

ok($mail_add_aliases = $plesk->mail_add_aliases($domainID,$login,'mootman'),'added_new_alias');
is_deeply($mail_add_aliases->results, $legit, 'mail_add_alias matches test data');


ok($mail_delete_aliases = $plesk->mail_delete_aliases($domainID,$login,'mootman'),'added_new_alias');
is_deeply($mail_delete_aliases->results, $legit, 'mail_add_alias matches test data');
