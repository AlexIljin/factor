! Copyright (C) 2020 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING: byte-arrays help.markup help.syntax io.encodings.utf8 kernel math
sodium.secure-memory strings ;
IN: sqrl.enscrypt

HELP: ?encode2
{ $values
    { "str1" string } { "str2" string }
    { "bytes1" byte-array } { "bytes2" byte-array }
}
{ $description "If either or both of the input parameters are strings, convert them to byte-arrays. Use " { $link utf8 } " for the encoding." } ;

HELP: N
{ $description "Parameter of the Scrypt, specifies how much memory to use. In the future it may be tweaked to be a higher value, in which case it would be loaded from settings. For the simplicity of the first implementation we keep it a constant." } ;

HELP: enscrypt
{ $values
    { "password" string } { "salt" string } { "iterations" integer }
    { "32-bytes" byte-array }
}
{ $description "Use EnScrypt scheme to hash the password with the given salt. The hashing is performed the given number of iterations." } ;

HELP: enscrypt-to
{ $values
    { "password" string } { "salt" string } { "iterations" integer } { "hash-memory" byte-array }
    { "hash-memory'" byte-array }
}
{ $description "A securable version of " { $link enscrypt } ", which stores the output in the given " { $snippet "hash-memory" } ". It's recommended to use this word and give it an instance of " { $link secure-memory } " to avoid storing the hash value in the open." } ;

HELP: scrypt-bytes
{ $values
    { "password-bytes" byte-array } { "salt-bytes" byte-array }
    { "bytes" byte-array }
}
{ $description "Perform one iteration of Scrypt on " { $link byte-array } "s." } ;

HELP: timed-enscrypt
{ $values
    { "password" string } { "salt" string } { "msec" integer }
    { "32-bytes" byte-array } { "iterations" integer }
}
{ $description "Repeatedly EnScrypt the given " { $snippet "password" } " with the " { $snippet "salt" } " until the given number of milliseconds elapses. Return the hashed value and the number of iterations reached. The latter number can be passed to " { $link enscrypt } " to produce the same hash value." } ;

HELP: timed-enscrypt-to
{ $values
    { "password" string } { "salt" string } { "msec" integer } { "hash-memory" byte-array }
    { "hash-memory'" byte-array } { "iterations" integer }
}
{ $description "A securable version of " { $link timed-enscrypt } ", which stores the output in the given " { $snippet "hash-memory" } ". It's recommended to use this word and give it an instance of " { $link secure-memory } " to avoid storing the hash value in the open." } ;

ARTICLE: "sqrl.enscrypt" "EnScrypt"
"The " { $vocab-link "sqrl.enscrypt" } " vocab implements the EnScrypt hash as described in the \"SQRL Cryptography\" document, see " { $url "https://www.grc.com/sqrl/sqrl_cryptography.pdf" } ". The Scrypt implementation is taken from the " { $vocab-link "sodium" } " library."
$nl
"EnScrypt with a known number of iterations:"
{ $subsections enscrypt-to enscrypt }
"Time-based EnScrypt:"
{ $subsections timed-enscrypt-to timed-enscrypt } ;

ABOUT: "sqrl.enscrypt"
