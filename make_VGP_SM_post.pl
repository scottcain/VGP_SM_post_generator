#!/usr/bin/env perl
use strict;
use warnings;

# check env for OPENAI_API_KEY

use local::lib;
use lib './lib';
use VGPSMPost;

#die <<END unless @ARGV;
#Usage: $0 "post description"
#Provide several arguments...
#END

my $species = 'Callospermophilus lateralis';
my @author_list = qw('me' 'you');
my $length  = '250MB';
my $usegalaxy = 1;
my $special_authors = 'me=Annotated;you=Assembled';
my @images = ('Golden-mantled Ground Squirrel from WikiMedia|https://upload.wikimedia.org/wikipedia/commons/5/58/Golden-mantled_Ground_Squirrel_-_Callospermophilus_lateralis%2C_Lassen_Volcanic_National_Park%2C_California.jpg');
my $config;

my $post = VGPSMPost->build_markdown(
  $species,
  \@author_list,
  $length,
  $usegalaxy,
  $special_authors,
  \@images,
  $config
);
print "$post\n";

