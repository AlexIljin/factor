! Copyright (C) 2020 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING:
    accessors alien alien.c-types byte-arrays calendar classes.struct
    destructors fry init io.binary kernel namespaces sequences
    sodium sodium.ffi sodium.secure-memory
    system threads
;

IN: sqrl.entropy-harvester

<PRIVATE

SYMBOL: global-state

: (get-entropy) ( -- 64bytes )
    global-state get-global [
        clone [
            >c-ptr crypto_auth_hmacsha512_BYTES <byte-array>
            [ crypto_auth_hmacsha512_final check0 ] keep
        ] with-disposal
    ] with-read-access ;

: with-random-key ( ..a quot: ( ..a key keylen -- ..b ) -- ..b )
    '[
        crypto_auth_hmacsha512_KEYBYTES new-secure-memory &dispose >c-ptr dup
        crypto_auth_hmacsha512_keygen crypto_auth_hmacsha512_KEYBYTES @
    ] with-destructors ; inline

: random-system-data ( -- bytes )
    crypto_auth_hmacsha512_BYTES n-random-bytes nano-count 8 >le append ;

: (init-harvester) ( secure-memory -- )
    >c-ptr [ crypto_auth_hmacsha512_init check0 ] with-random-key ;

: (harvest-entropy) ( bytes -- )
    global-state get-global [
        >c-ptr swap dup length crypto_auth_hmacsha512_update check0
    ] with-write-access ;

PRIVATE>

: init-harvester ( -- )
    sodium-init crypto_auth_hmacsha512_state heap-size [
        dup (init-harvester) global-state set-global
    ] with-new-secure-memory ;

: harvest-entropy ( -- )
    random-system-data (harvest-entropy) ;

: get-entropy ( -- 64bytes )
    (get-entropy) dup random-system-data append (harvest-entropy) ;

<PRIVATE

: harvest-thread ( -- )
    harvest-entropy 1 seconds sleep harvest-thread ;

PRIVATE>

[
    [ init-harvester harvest-thread ] "SQRL Entropy Harvester" spawn
    drop
] "SQRL Entropy Harvester" add-startup-hook
