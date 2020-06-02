! Copyright (C) 2020 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING:
    byte-arrays destructors
    io.encodings.string io.encodings.utf8
    kernel libc locals
    math math.vectors
    sequences sequences.extras
    sodium sodium.ffi sodium.secure-memory
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

: vbitxor! ( seq1 seq2 -- seq1' )
    [ bitxor ] 2map! ; inline

! Perform n iterations of the Scrypt hashing. Initial value of hash-memory
! contains salt for the first iteration. Intermediate hash values are stored in
! a temporary secure-memory.
: (enscrypt-to) ( n+1 password-bytes hash-memory -- hash-memory' )
    [
        32 [| n pass hash mem |
            mem &dispose hash 32 memcpy
            hash n 1 - [ pass mem mem scrypt-bytes-to vbitxor! ] times
        ] with-new-secure-memory
    ] with-destructors ; inline

: enscrypt-to ( iterations password salt hash-memory -- hash-memory' )
    [ ?encode2 dupd ] dip scrypt-bytes-to
    pick 1 > [ (enscrypt-to) ] [ 2nip ] if ;

: enscrypt ( iterations password salt -- 32-bytes )
    32 <byte-array> enscrypt-to ;

:: timed-enscrypt ( password salt msec -- 32-bytes iterations )
    msec 1000000 * nano-count + 1 :> ( target-time iterations! )
    password salt ?encode2 dupd scrypt-bytes dup
    [ nano-count target-time < ] [
        [ dupd scrypt-bytes dup ] dip vbitxor
        iterations 1 + iterations!
    ] while 2nip iterations ;
