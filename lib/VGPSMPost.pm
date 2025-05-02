#########################################################3
package VGPSMPost;

use strict;
use warnings;
use OpenAI::API::Request::Chat;

#  --species: "Genus species"
#  --authors: list of email address, or a file that contains them
#  --length: Overall genome length
#  --config: Config file with name, email, SM tags of everybody (tab delimited because why do json)
#  --UseGalaxy tag: to specify whether to mention UseGalaxy and cross post
#  --images tag: Option to include a list of urls for images
#  --special-authors: quoted tag values pairs like "Assembly=Linelle Abueg on Galaxy;Curation=Kirsty McCaffrey" (will go verbatim after the text of the post)

sub build_markdown {
    my $class = shift;
    my $species = shift;
    my $authors = shift; # reference to an array
    my $length  = shift;
    my $usegalaxy = shift;
    my $special_authors = shift; # string with semicolon delimited tag=value pairs
    my $images = shift; # reference to an array
    my $config = shift; # path to local config file

    my $media_text   = $class->make_media_text($usegalaxy);
    #    my $mention_text = $class->make_mention_text($authors, $usegalaxy);
    my $hastag_text  = $class->make_hashtag_text($usegalaxy);

    my $images_text  = $class->make_images_text($images);

    my $body = $class->make_body($species, $length, $usegalaxy, $images);

    my $special_author_list = $special_authors ? 
                                 $class->make_special_author_list($special_authors) :
                                 '';

    $body = "---\n$media_text\n$hastag_text\n---\n$images_text\n$body\n\n$special_author_list";

    return $body;
}

sub make_body {
    my $class = shift;
    my $SPECIES = shift;
    my $LENGTH  = shift;
    my $GALAXY  = shift;

    my $galaxy_part = '';
    if ($GALAXY) {
        $galaxy_part = " and that it was assembled and annotated using https://usegalaxy.org";
    }

    my $prompt =<<END;
Write a social media post that is at most 750 characters long announcing the sequencing of the $LENGTH
genome of $SPECIES by the Vertebrate Genome Lab. Mention its common name $galaxy_part. Mention at least
one interesting fact about the species.
END

    my $req = OpenAI::API::Request::Chat->new(
 model => 'gpt-4o-mini',
 messages => [
     {role => "system", "content" => "You are a helpful assistant."},
     {role => "user",   "content" => $prompt},
 ],
      );
    my $resp = $req->send();

    my $body = $resp->{choices}[0]{message}{content};

    

    return $body;
}

sub make_special_author_list {
    my $class = shift;
    my $special_authors = shift;

    my $text;

    my @specials = split /;/, $special_authors;
    for my $sp (@specials) {
        my ($auth, $role) = split /=/, $sp;
        $text .= "$role by $auth\n";
    }

    return $text;
}

sub make_media_text {
    my $class = shift;
    my $usegalaxy = shift;

    my $text = <<END
media:
 - mastodon-vgp
 - bluesky-vgp
END
;

    if ($usegalaxy) {
        $text .= <<GALAXY
 - mastodon-galaxyproject
 - bluesky-galaxyproject
 - linkedin-galaxyproject
GALAXY
;
    }
    return $text;
}

sub make_hashtag_text {
    my $class = shift;
    my $usegalaxy = shift;

    my $text = '';
    if ($usegalaxy) {
        $text = <<GALAXY
 mastodon-galaxyproject:
  - UseGalaxy
  - VertebrateGenomesProject
 bluesky-galaxyproject:
  - UseGalaxy
  - VertebrateGenomesProject
 linkedin-galaxyproject:
  - UseGalaxy
  - VertebrateGenomesProject
 mastodon-vgp:
  - UseGalaxy
 bluesky-vgp:
  - UseGalaxy
GALAXY
;
    }

    return $text;
}

sub make_images_text {
    my $class = shift;
    my $images = shift; # reference to an array

    my $images_text = '';

    for my $item (@{$images}) {
        my ($desc, $url)  = split /\|/, $item;
        $images_text .= "![$desc]($url)\n";
    }

    return $images_text;
}

1;
