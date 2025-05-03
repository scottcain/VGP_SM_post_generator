#!/usr/bin/env perl
use strict;
use warnings;

# check env for OPENAI_API_KEY

use local::lib;
use lib './lib';
use VGPSMPost;
use Config::INI::Reader;
use Getopt::Long;
use Data::Dumper;

#die <<END unless @ARGV;
#Usage: $0 "post description"
#Provide several arguments...
#END

my $species = 'Callospermophilus lateralis';
my @author_list = qw(scott@scottcain.net fake@example.com);
my $length  = '250MB';
my $usegalaxy = 1;
my $special_authors = 'me=Annotated;you=Assembled';
my @images = ('Golden-mantled Ground Squirrel from WikiMedia|https://upload.wikimedia.org/wikipedia/commons/5/58/Golden-mantled_Ground_Squirrel_-_Callospermophilus_lateralis%2C_Lassen_Volcanic_National_Park%2C_California.jpg');
my $config = 'handles.conf';

my $authors;
my $imagelist;
my $nousegalaxy;

GetOptions (
    "species=s"          => \$species,
    "author_list=s"      => \$authors,
    "length=s"           => \$length,
    "usegalaxy"          => \$usegalaxy,
    "nousegalaxy"        => \$nousegalaxy,
    "special_authors=s"  => \$special_authors,
    "images=s"           => \$imagelist,
    "config=s"           => \$config,
) or die("Error in command line arguments\n");

if ($authors) {
    @author_list = split(/,/, $authors);
}
if ($imagelist) {
    @images = split(/\|\|\|/, $imagelist); # using a delimiter of "|||"
}
if ($nousegalaxy) {
    $usegalaxy = 0;
}

my $config_hash = Config::INI::Reader->read_file('handles.conf');

my $post = VGPSMPost->build_markdown(
  $species,
  \@author_list,
  $length,
  $usegalaxy,
  $special_authors,
  \@images,
  $config_hash #hash reference
);
print "$post\n";

