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
my $legit =  {'filter-id' => '1',
          'status' => 'ok',
          'data' => {
                    'limits' => {
                                'limit' => {
                                           'max_resp' => {
                                                         'value' => '-1'
                                                       },
                                           'max_mg' => {
                                                       'value' => '-1'
                                                     },
                                           'max_db' => {
                                                       'value' => '-1'
                                                     },
                                           'max_webapps' => {
                                                            'value' => '-1'
                                                          },
                                           'max_traffic' => {
                                                            'value' => '-1'
                                                          },
                                           'disk_space' => {
                                                           'value' => '-1'
                                                         },
                                           'max_dom_aliases' => {
                                                                'value' => '-1'
                                                              },
                                           'max_box' => {
                                                        'value' => '-1'
                                                      },
                                           'max_subdom' => {
                                                           'value' => '-1'
                                                         },
                                           'max_wu' => {
                                                       'value' => '-1'
                                                     },
                                           'expiration' => {
                                                           'value' => '-1'
                                                         },
                                           'mbox_quota' => {
                                                           'value' => '-1'
                                                         },
                                           'max_maillists' => {
                                                              'value' => '-1'
                                                            },
                                           'max_redir' => {
                                                          'value' => '-1'
                                                        }
                                         }
                              },
                    'user' => {
                              'country' => {},
                              'pcode' => {},
                              'phone' => {},
                              'state' => {},
                              'cname' => {},
                              'email' => {},
                              'city' => {},
                              'multiply_login' => 'false',
                              'fax' => {},
                              'pname' => {},
                              'address' => {},
                              'perms' => {
                                         'permission' => {
                                                         'manage_webapps' => {
                                                                             'value' => 'false'
                                                                           },
                                                         'select_db_server' => {
                                                                               'value' => 'false'
                                                                             },
                                                         'manage_subdomains' => {
                                                                                'value' => 'false'
                                                                              },
                                                         'dashboard' => {
                                                                        'value' => 'true'
                                                                      },
                                                         'allow_local_backups' => {
                                                                                  'value' => 'false'
                                                                                },
                                                         'manage_anonftp' => {
                                                                             'value' => 'false'
                                                                           },
                                                         'manage_phosting' => {
                                                                              'value' => 'false'
                                                                            },
                                                         'manage_dashboard' => {
                                                                               'value' => 'true'
                                                                             },
                                                         'manage_domain_aliases' => {
                                                                                    'value' => 'false'
                                                                                  },
                                                         'allow_ftp_backups' => {
                                                                                'value' => 'false'
                                                                              },
                                                         'manage_sh_access' => {
                                                                               'value' => 'false'
                                                                             },
                                                         'manage_maillists' => {
                                                                               'value' => 'false'
                                                                             },
                                                         'manage_virusfilter' => {
                                                                                 'value' => 'false'
                                                                               },
                                                         'stdgui' => {
                                                                     'value' => 'true'
                                                                   },
                                                         'manage_webstat' => {
                                                                             'value' => 'true'
                                                                           },
                                                         'manage_log' => {
                                                                         'value' => 'false'
                                                                       },
                                                         'manage_dns' => {
                                                                         'value' => 'false'
                                                                       },
                                                         'manage_spamfilter' => {
                                                                                'value' => 'false'
                                                                              },
                                                         'manage_crontab' => {
                                                                             'value' => 'false'
                                                                           },
                                                         'manage_not_chroot_shell' => {
                                                                                      'value' => 'false'
                                                                                    },
                                                         'manage_quota' => {
                                                                           'value' => 'false'
                                                                         },
                                                         'manage_ftp_password' => {
                                                                                  'value' => 'false'
                                                                                }
                                                       }
                                       },
                              'enabled' => 'false'
                            },
                    'hosting' => {
                                 'none' => {}
                               },
                    'gen_info' => {
                                  'dns_ip_address' => '114.31.73.30',
                                  'htype' => 'none',
                                  'status' => '0',
                                  'ascii-name' => 'distributeit.com.au',
                                  'client_id' => '1',
                                  'name' => 'distributeit.com.au',
                                  'real_size' => '319488',
                                  'guid' => '2a4b8e61-e531-4dcb-9142-859af26790de'
                                }
                  },
          'id' => '1'
}; 

ok(my $r = $plesk->client_get('internal'), 'got a response object for client_get');
if ($r->errortext) {
    note('returned error'.$response->errortext);
} else {
  ok($response = $plesk->domain_get_all_client($r->id), 'got a response object for domain_get_all_client');
  if ($response->errortext) {
    note('returned error'.$response->errortext);
  } else {
    ok(blessed($response), 'response object is blessed');
    $legit->{'data'}->{'gen_info'}->{'real_size'} = $response->results->[0]->{'data'}->{'gen_info'}->{'real_size'};
    $legit->{'data'}->{'gen_info'}->{'cr_date'} = $response->results->[0]->{'data'}->{'gen_info'}->{'cr_date'};
    is_deeply($response->results->[0], $legit, 'domain_get_all_client matches test data');
  }
}
