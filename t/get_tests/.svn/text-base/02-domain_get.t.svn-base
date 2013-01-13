# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Plesk.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Data::Dumper;
use Test::More tests => 4;
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

my $legit = {
           'filter-id' => 'testdistributeit.com.au',
           'status' => 'ok',
           'data' => {
                     'hosting' => {
                                  'vrt_hst' => {
                                               'ip_address' => '114.31.73.30',
                                               'property' => {
                                                             'ftp_password' => {
                                                                               'value' => 'night1543'
                                                                             },
                                                             'fp_admin_login' => {
                                                                                 'value' => {}
                                                                               },
                                                             'fp' => {
                                                                     'value' => 'false'
                                                                   },
                                                             'ftp_password_type' => {
                                                                                    'value' => 'plain'
                                                                                  },
                                                             'same_ssl' => {
                                                                           'value' => 'false'
                                                                         },
                                                             'fastcgi' => {
                                                                          'value' => 'false'
                                                                        },
                                                             'asp_dot_net' => {
                                                                              'value' => 'false'
                                                                            },
                                                             'php' => {
                                                                      'value' => 'false'
                                                                    },
                                                             'ftp_quota' => {
                                                                            'value' => '-1'
                                                                          },
                                                             'webstat' => {
                                                                          'value' => 'none'
                                                                        },
                                                             'errdocs' => {
                                                                          'value' => 'false'
                                                                        },
                                                             'shell-forbidden' => {
                                                                                  'value' => {}
                                                                                },
                                                             'asp' => {
                                                                      'value' => 'false'
                                                                    },
                                                             'python' => {
                                                                         'value' => 'false'
                                                                       },
                                                             'fp_ssl' => {
                                                                         'value' => 'false'
                                                                       },
                                                             'ssl' => {
                                                                      'value' => 'false'
                                                                    },
                                                             'php_safe_mode' => {
                                                                                'value' => 'true'
                                                                              },
                                                             'fp_admin_password' => {
                                                                                    'value' => {}
                                                                                  },
                                                             'cgi' => {
                                                                      'value' => 'false'
                                                                    },
                                                             'webstat_protected' => {
                                                                                    'value' => 'false'
                                                                                  },
                                                             'ftp_login' => {
                                                                            'value' => 'testmattr'
                                                                          },
                                                             'perl' => {
                                                                       'value' => 'false'
                                                                     },
                                                             'sb_publishing' => {
                                                                                'value' => 'false'
                                                                              },
                                                             'coldfusion' => {
                                                                             'value' => 'false'
                                                                           },
                                                             'miva' => {
                                                                       'value' => 'false'
                                                                     },
                                                             'ssi' => {
                                                                      'value' => 'false'
                                                                    },
                                                             'at_domains' => {
                                                                             'value' => 'false'
                                                                           },
                                                             'fp_auth' => {
                                                                          'value' => 'false'
                                                                        }
                                                           }
                                             }
                                },
                     'gen_info' => {
                                   'dns_ip_address' => '114.31.73.30',
                                   'htype' => 'vrt_hst',
                                   'status' => '0',
                                   'ascii-name' => 'testdistributeit.com.au',
                                   'cr_date' => '2009-03-31',
                                   'client_id' => '19',
                                   'name' => 'testdistributeit.com.au',
                                   'real_size' => '0',
                                   'guid' => 'f16bb65f-3c56-4f13-b5e5-19d603fe5c98'
                                 }
                   },
           'id' => '12'
         };
my $plesk = eval { 

  Net::Plesk->new(
    'POST'              => "https://$hostname:8443/enterprise/control/agent.php",
    ':HTTP_AUTH_LOGIN'  => $username,
    ':HTTP_AUTH_PASSWD' => $password,
  );

};

ok(blessed($plesk), 'got a plesk object');

ok(my $r = $plesk->domain_get('testdistributeit.com.au'), 'got a response object');

  $legit->{'data'}->{'gen_info'}->{'guid'} = $r->results->[0]->{'data'}->{'gen_info'}->{'guid'};
  $legit->{'data'}->{'gen_info'}->{'client_id'} = $r->results->[0]->{'data'}->{'gen_info'}->{'client_id'};
  $legit->{'data'}->{'gen_info'}->{'cr_date'} = $r->results->[0]->{'data'}->{'gen_info'}->{'cr_date'};
  $legit->{'data'}->{'gen_info'}->{'real_size'} = $r->results->[0]->{'data'}->{'gen_info'}->{'real_size'};

  $legit->{'id'} = $r->results->[0]->{'id'};

if ($r->errortext) {
  note('returned error from domain_get: '.$r->errortext);
} else {
  
  is_deeply($r->results, $legit, 'got legit results from domain_get');
}

