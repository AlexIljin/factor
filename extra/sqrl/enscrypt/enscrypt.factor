! Copyright (C) 2020 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING:
    byte-arrays
    io.encodings.string io.encodings.utf8
    kernel
    math math.vectors
    sequences
    sodium sodium.ffi
;

IN: sqrl.enscrypt

CONSTANT: N 512

: scrypt-bytes ( password-bytes salt-bytes -- bytes )
    [ dup length ] bi@ N 256 1 32 <byte-array> [
        32 crypto_pwhash_scryptsalsa208sha256_ll check0
    ] keep ; inline

: enscrypt ( password salt iterations -- 32-bytes )
    [ [ utf8 encode ] bi@ dupd scrypt-bytes dup ] dip 1 - [
        [ dupd scrypt-bytes dup ] dip vbitxor
    ] times 2nip ;
