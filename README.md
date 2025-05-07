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

--usegalaxy

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


