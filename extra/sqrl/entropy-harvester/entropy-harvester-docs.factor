! Copyright (C) 2020 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING: byte-arrays help.markup help.syntax sodium.secure-memory
sqrl.entropy-harvester.private ;
IN: sqrl.entropy-harvester

ABOUT: "sqrl.entropy-harvester"

ARTICLE: "sqrl.entropy-harvester" "SQRL Entropy Harvester"
"The " { $vocab-link "sqrl.entropy-harvester" } " vocab implements a thread that churns random data in the background to provide high quality entropy on demand to other SQRL vocabs. The background thread is started when the vocab is loaded." $nl
"Internally, SHA-512 hash is fed data from the libsodium's random data generator and the current value of the high precision system clock." $nl
"Get some random data from the Harvester:"
{ $subsections get-entropy get-entropy-to }
"Perform an extra step of entropy harvesting:"
{ $subsections harvest-entropy } ;

HELP: init-harvester
{ $description "Initialize the Entropy Harvester by setting up the " { $link global-state } " variable." } ;

HELP: get-entropy
{ $description "Return a freshly allocated " { $link byte-array } " with 64 bytes of random data. Call multiple times to get as much data as necessary." } ;

HELP: get-entropy-to
{ $description "Write new 64 bytes of random data to the " { $snippet "64bytes" } ", which can be a " { $link byte-array } " or a " { $link secure-memory } " with write access. Modifies " { $snippet "64bytes" } "." } ;

{ get-entropy-to get-entropy } related-words

HELP: harvest-entropy
 { $description "It's only necessary to call this word if you want to increase the amount of random data churning in the Entropy Harvester between calls to " { $link get-entropy } "." } ;
