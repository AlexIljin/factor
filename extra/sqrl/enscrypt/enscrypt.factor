! Copyright (C) 2020 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING:
    byte-arrays
    io.encodings.string io.encodings.utf8
    kernel locals
    math math.vectors
    sequences
    sodium sodium.ffi
    strings system
;

IN: sqrl.enscrypt

CONSTANT: N 512

! hash-bytes must be at least 32 bytes long, it will contain the hash output.
: scrypt-bytes-to ( password-bytes salt-bytes hash-bytes -- hash-bytes' )
    [
        [ dup length ] tri@ [ N 256 1 ] 2dip
        crypto_pwhash_scryptsalsa208sha256_ll check0
    ] keep ; inline

: scrypt-bytes ( password-bytes salt-bytes -- bytes )
    32 <byte-array> scrypt-bytes-to ; inline

: ?encode2 ( str1 str2 -- bytes1 bytes2 )
    [ dup string? [ utf8 encode ] when ] bi@ ;

: enscrypt ( iterations password salt -- 32-bytes )
    ?encode2 dupd scrypt-bytes dup roll 1 - [
        [ dupd scrypt-bytes dup ] dip vbitxor
    ] times 2nip ;

:: timed-enscrypt ( password salt msec -- 32-bytes iterations )
    msec 1000000 * nano-count + 1 :> ( target-time iterations! )
    password salt ?encode2 dupd scrypt-bytes dup
    [ nano-count target-time < ] [
        [ dupd scrypt-bytes dup ] dip vbitxor
        iterations 1 + iterations!
    ] while 2nip iterations ;
