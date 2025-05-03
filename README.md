# VGP_SM_post_generator
A LLM-powered tool for generating social media posts announcing genomes assembled by VGP.

```
  perl  make_VGP_SM_post.pl \
        --nousegalaxy \
        --species "Zonotrichia albicollis" \
        --images "The White-throated Sparrow|https://genomeark.s3.amazonaws.com/species/Zonotrichia_albicollis/bZonAlb1/img/bZonAlb1_1.png|||These birds follow a unique mating pattern - white morphs exclusively pair with tan mates and vice versa. This unusual system has earned them the nickname 'the bird with four sexes'|https://genomeark.s3.amazonaws.com/species/Zonotrichia_albicollis/bZonAlb1/img/bZonAlb1_3.png" --author_list "scott@scottcain.net" --length "100MB" \
        --special "me=Annotated;them=Assembled"
```


