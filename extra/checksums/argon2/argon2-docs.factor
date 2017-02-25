! Copyright (C) 2017 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING: help.markup help.syntax ;
IN: checksums.argon2

ABOUT: "checksums.argon2"

ARTICLE: "checksums.argon2" "Argon2 key derivation function"
"Argon2 is a key derivation function that won the Password Hashing Competition in July 2015. " { $snippet "https://en.wikipedia.org/wiki/Argon2" }
$nl
"The " { $vocab-link "checksums.argon2" } " vocabulary currently provides only minimal access to the argon2 library. If the full bindings are ever created, Factor may be listed in the README of the official repo: " { $snippet "https://github.com/P-H-C/phc-winner-argon2/blob/master/README.md" }
;
