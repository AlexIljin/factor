! Copyright (C) 2020 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING:
    accessors byte-arrays
    checksums checksums.common
    destructors kernel
    math math.vectors
    sequences
    sodium sodium.ffi sodium.secure-memory
;

IN: sqrl.enhash

SINGLETON: enhash
INSTANCE: enhash block-checksum

<PRIVATE

TUPLE: enhash-state < disposable
    { mem secure-memory }
    { output maybe{ byte-array } } ;

M: enhash-state dispose* mem>> dispose ;

: hash-in-place ( 32bytes -- 32bytes' )
    dup dup dup length dup crypto_hash_sha256_BYTES assert=
    crypto_hash_sha256 check0 ;

: enhash-step ( xored hashed -- xored' hashed' )
    hash-in-place tuck vbitxor swap ;

: (get-checksum) ( enhash-state -- checksum )
    mem>> [
        crypto_hash_sha256_BYTES <byte-array>
        [ crypto_hash_sha256_final check0 ] keep
    ] with-write-access dup clone 15 [ enhash-step ] times drop ;

PRIVATE>

M: enhash initialize-checksum-state
    drop crypto_hash_sha256_statebytes [
        dup crypto_hash_sha256_init 0 = [
            enhash-state new-disposable swap >>mem
        ] [ dispose call-fail ] if
    ] with-new-secure-memory ;

M: enhash-state add-checksum-bytes
    over mem>> [
        swap dup length crypto_hash_sha256_update check0
    ] with-write-access ;

M: enhash-state get-checksum
    dup output>> [
        dup (get-checksum) [ >>output ] keep
    ] unless* nip ;
