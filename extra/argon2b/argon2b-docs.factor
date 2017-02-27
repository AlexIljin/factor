! Copyright (C) 2017 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING: help.markup help.syntax ;
IN: argon2b

ABOUT: "argon2b"

ARTICLE: "argon2b" "Argon2b library"
"Argon2 is a key derivation function that won the Password Hashing Competition in July 2015. It is based on the Blake2b hash. See " { $snippet "https://en.wikipedia.org/wiki/Argon2" } ", " { $snippet "https://en.wikipedia.org/wiki/BLAKE_(hash_function)" } "."
$nl
"The " { $vocab-link "argon2b" } " vocabulary provides FFI to the argon2b library, which exports API for both Argon2 and Blake2b hash: " { $snippet "https://github.com/AlexIljin/phc-winner-argon2" }
;

HELP: BLAKE2B_OUTBYTES
{ $description "This is the default size of the Blake2b hash output." } ;

HELP: blake2b
{ $description "Simple one-call implementation, for use cases when all of the data to be hashed can be put in one input buffer. Key is optional. Returns 0 on success." } ;
