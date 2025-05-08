# VGP_SM_post_generator
A LLM-powered tool for generating social media posts announcing genomes assembled by VGP.

```
  perl  make_VGP_SM_post.pl \
        --nousegalaxy \
        --species "Zonotrichia albicollis" \
        --images "The White-throated Sparrow|https://genomeark.s3.amazonaws.com/species/Zonotrichia_albicollis/bZonAlb1/img/bZonAlb1_1.png|||These birds follow a unique mating pattern - white morphs exclusively pair with tan mates and vice versa. This unusual system has earned them the nickname 'the bird with four sexes'|https://genomeark.s3.amazonaws.com/species/Zonotrichia_albicollis/bZonAlb1/img/bZonAlb1_3.png" \
        --author_list "scott@scottcain.net" \
        --length "100MB" \
        --special "me=Annotated;them=Assembled" \
        --git
```

## Options

--[no]usegalaxy

Flag to add a comment that the genome was assembled and annotated at UseGalaxy (default). Adding the 'no' explicitly turns this off.

--species

Quoted text of the Genus and species (required).

--images

A list of image descriptions and URLs. Each set of description and URL is delimited by a vertical bar `|` and the sets of descriptions-URL commbinations are delimited by three vertical bars. See the example invocation of the command above for what this should look like (optional).

--author_list

Comma delimited list of author emails (optional).

--length

Genome length in "human-readable" numbers (eg, 100MB) (optional).

--special_authors

A list of semicolon delimited "tag=value" pairs, where the tag is the author's name and the value is the action they performed, for example, "Scott Cain=Annotated" (optional)

--git

A flag to create a git branch, commit the newly created markdown file and create a pull request. Note that to work, the script must be invoked in a checked out GitHub repo (optional).

--config <filename>

Default value: `handles.conf`. Points at an ini formated file containing Mastodon and BlueSky user handles corresponding to the author emails provided in the `--author_list` option, where the entries look like:
```
[email@example.com]
mastodon=example@example.social
bluesky=example.bluesky.com
```

## Prerequisites

* Perl modules:
  - local::lib - While strictly not necessary, using `local::lib` makes perl module management much easier. See https://metacpan.org/pod/local::lib#The-bootstrapping-technique for installing `local::lib` without `sudo`.
  - Config::INI - If you have access to a package manager, install cpanm ("cpan minus") will make installing perl modules easier. After install `local::lib`, just running `cpanm Config::INI` will install the module.

* An OpenAI/ChatGPT API key - this is what I followed to get the API key: https://dev.to/onlinemsr/how-to-get-chatgpt-api-key-a-step-by-step-guide-507k  After getting the key, a environment variable needs to be set with the contents of the key: `export OPEN_API_KEY=thekey`.  This command can be placed in a .bashrc or .zshrc file to make it part of the environment on login.

* The GitHub command line interface (`gh`): see https://cli.github.com to install.

* A github checkout of the galaxy-social github repo

## Usage

In order for the GitHub aspects of the tool to work (commiting, making pull requests), this tool should be executed in the galaxy-social repo in the directory where the resulting markdown file should reside.

There are two modes of operation: testing and committing. If you are using testing mode (by omitting the `--git` flag), the tool will create a markdown file (with the file name starting with the OS `time` to make it unique). 

If operating in committing mode (with the `--git` flag), after creating the markdown file, to tool will create a git branch, commit the file, create a pull request to merge into main, and then checkout the `main` branch (to prevent accidentally working in the bot-created branch).

## Potential improvements

1. The prompt could probably be improved.  The current prompt looks like this:
```
Write a social media post that is at most 750 characters
long announcing the sequencing of the $LENGTH genome of
$SPECIES by the Vertebrate Genome Lab. Mention its common
name $galaxy_part. Mention at least one interesting fact
about the species.
```
2. The formating of post breaks could be improved, making them look good in BlueSky threads.  Doing this generically seems kind of hard and not really worth the effort (in my opinion). For "special" posts, more human effort can be expended to make the posts better, whereas for not-special posts, the bot output should be fine.
