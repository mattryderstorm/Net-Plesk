package Net::Plesk::Response;

use strict;
use XML::Simple;
use XML::XPath;
use XML::XPath::XMLParser;
use Data::Dumper;
use DateTime;

=head1 NAME

Net::Plesk::Response - Plesk response object

=head1 SYNOPSIS

  my $response = $plesk->some_method( $and, $args );

  if ( $response->is_success ) {

    my $id  = $response->id;
    #...

  } else {

    my $error = $response->error; #error code
    my $errortext = $response->errortext; #error message
    #...
  }

=head1 DESCRIPTION

The "Net::Plesk::Response" class represents Plesk responses.

=cut

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = {};
  bless($self, $class);

  my $data = shift;

  if ($data =~ m/xml \s+ version=" \d+ [.] \d+ " [^>]+ > (.*)/xms) { 
    $data=$1;
  }else{
    $data =~ s/[^\w\s]/ /g;  # yes, we lose stuff
    $data = '<?xml version="1.0"?>' .
      '<packet version="' . $self->{'version'} . '">' .
      "<system><status>error</status><errcode>500</errcode>" .
      "<errtext>Malformed Plesk response:" . $data .  "</errtext>".
      "</system></packet>";
  } 

  my $xp = XML::XPath->new(xml => $data);
  my $nodeset = $xp->find('//result');
  foreach my $node ($nodeset->get_nodelist) {
    push @{$self->{'results'}}, XML::XPath::XMLParser::as_string($node);
  }
  $nodeset = $xp->find('//system');
  foreach my $node ($nodeset->get_nodelist) {
    my $parsed = XML::XPath::XMLParser::as_string($node);
    $parsed =~ s/\<(\/?)system\>/<$1result>/ig;
    push @{$self->{'results'}}, $parsed;
  }

  $self;
}

sub is_success { 
  my $self = shift;
  my $status = 1;
  foreach my $result (@{$self->{'results'}}) {
    $status = (XMLin($result)->{'status'} eq 'ok');
    last unless $status;
  }
  $status;
}

sub error {
  my $self = shift;
  my @errcode;
  foreach my $result (@{$self->{'results'}}) {
    my $errcode = XMLin($result)->{'errcode'};
    push @errcode, $errcode if $errcode;
  }
  return wantarray ? @errcode : $errcode[0];
}

sub errortext {
  my $self = shift;
  my @errtext;
  foreach my $result (@{$self->{'results'}}) {
    my $errtext = XMLin($result)->{'errtext'};
    push @errtext, $errtext if $errtext;
  }
  return wantarray ? @errtext : $errtext[0];
}

sub id {
  my $self = shift;
  my @id;
  foreach my $result (@{$self->{'results'}}) {
    my $id = XMLin($result)->{'id'};
    push @id, $id if $id;
  }
  return wantarray ? @id : $id[0];
}

sub results {
  my ($self) = @_;

  my $results = $self->{results} or return;
  my @ret;

  foreach my $result (@$results) {
    push @ret, XMLin($result);
  }
 
   return wantarray ? @ret : \@ret;
 }

sub get_sso_prefs {
  my ($self) = @_;
  my %attributes;
  my $id;
 foreach my $result (@{$self->{'results'}}) {
      foreach my $attr (keys %{XMLin($result)->{'prefs'}}) {
             $attributes{$attr} = XMLin($result)->{'prefs'}->{$attr};
      }
 }
 return \%attributes;
}

sub iterate_items {
  my $self = shift;
  my @items;
      my %attributes;
  foreach my $result (@{$self->{'results'}}) {
      foreach my $attr (keys %{XMLin($result)}) {
        $attributes{$attr} = (XMLin($result)->{$attr});     
      }
  }
  return \%attributes;
}

sub attributes {
  my ($self,$key,$val) = @_;
  
  my %attributes;
  
  foreach my $result (@{$self->{'results'}}) {
      foreach my $attr (keys %{XMLin($result)}) {
        $attributes{$attr} = (XMLin($result)->{$attr});     
      }

      if (XMLin($result)->{$key} == $val) {
          return \%attributes;
      }
  }
}

sub spec_structure_aliases {
  my ($self) = @_;
  my %main_struct;
  my $id;
 foreach my $result (@{$self->{'results'}}) {
      $id = XMLin($result)->{'id'};
      my %attributes;
      foreach my $attr (keys %{XMLin($result)->{'info'}}) {
             $attributes{$attr} = XMLin($result)->{'info'}->{$attr};
      }
      $attributes{id} = $id;
      $main_struct{$id} = \%attributes;
  } 
 return \%main_struct;
}

sub spec_structure_mail {
  my ($self) = @_;
  my %main_struct;
  my $id;
 foreach my $result (@{$self->{'results'}}) {
      $id = XMLin($result)->{'mailname'}->{'id'};
      my %attributes;
      foreach my $attr (keys %{XMLin($result)->{'mailname'}}) {
             $attributes{$attr} = XMLin($result)->{'mailname'}->{$attr};
      }
      $main_struct{$id} = \%attributes;
  } 
 return \%main_struct;
}

sub spec_structure_ftp {
  my ($self) = @_;
  my %main_struct;
  my $id;
 foreach my $result (@{$self->{'results'}}) {
      $id = XMLin($result)->{'id'};
      my %attributes;
      foreach my $attr (qw/ftp_login ftp_password/) {
             $attributes{$attr} = XMLin($result)->{'data'}->{'hosting'}->{'vrt_hst'}->{'property'}->{$attr}->{'value'};
      }
      $attributes{id} = $id;
      $main_struct{$id} = \%attributes;
  }

  return \%main_struct;
}

sub gen_structure {
  my ($self) = @_;
  my %main_struct;
  my $id;
 foreach my $result (@{$self->{'results'}}) {
      $id = XMLin($result)->{'id'};
      if ($id eq '') {
        $main_struct{no_results} = 'yes';
        return \%main_struct;
      }
      my %attributes;
      foreach my $attr (keys %{XMLin($result)}) {
             $attributes{$attr} = XMLin($result)->{$attr};
      }
      $attributes{id} = $id;
      $main_struct{$id} = \%attributes;
  } 
 return \%main_struct;
}

sub domain_search {
 my ($self) = @_;
 my @domain_names;
 foreach my $result (@{$self->{'results'}}) {
      foreach my $attr (qw/name/) {
             push @domain_names,XMLin($result)->{'data'}->{'gen_info'}->{$attr};
      }
 } 
 return \@domain_names;
}

sub domain_structure {
  my ($self) = @_;
  my %main_struct;
  my $id;
 foreach my $result (@{$self->{'results'}}) {
      $id = XMLin($result)->{'id'};
      my %attributes;
      foreach my $attr (keys %{XMLin($result)->{'data'}->{'gen_info'}}) {
             $attributes{$attr} = XMLin($result)->{'data'}->{'gen_info'}->{$attr};
      }

      foreach my $attr (keys %{XMLin($result)->{'data'}->{'user'}}) {
             $attributes{$attr} = XMLin($result)->{'data'}->{'user'}->{$attr};
      }
      
      my $value = XMLin($result)->{'data'}->{'limits'}->{'limit'}->{'expiration'}->{'value'};
      my $dt = DateTime->from_epoch(epoch => $value);
      $attributes{'expiration'} = $dt->dmy('/');
      my @keys = keys %{XMLin($result)->{'data'}->{'aliases'}};
      $attributes{id} = $id;
      $main_struct{$id} = \%attributes;
  } 
 return \%main_struct;
}

=head1 BUGS

Needs better documentation.

=head1 SEE ALSO

L<Net::Plesk>,

=head1 AUTHOR

Jeff Finucane E<lt>jeff@cmh.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 Jeff Finucane

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
