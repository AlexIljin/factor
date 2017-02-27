! Copyright (C) 2017 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors argon2b byte-arrays checksums checksums.common
classes.struct destructors kernel math sequences ;
IN: checksums.blake2b

TUPLE: blake2b { output-size fixnum } ;
INSTANCE: blake2b block-checksum
C: <blake2b> blake2b

<PRIVATE

TUPLE: blake2b-state < disposable
    { state maybe{ blake2b_state } }
    { output-size fixnum }
    { output maybe{ byte-array } } ;

: check0 ( n -- )
    [ "blake2b result error" throw ] unless-zero ;

! This may not be necessary for blake2b implementation,
! but a checksum-state has to be a disposable.
M: blake2b-state dispose* drop ;

PRIVATE>

M: blake2b initialize-checksum-state
    blake2b_state <struct> swap output-size>>
    [ blake2b_init check0 ] 2keep
    blake2b-state new-disposable swap >>output-size swap >>state ;

M: blake2b-state add-checksum-bytes
    over state>> swap dup length blake2b_update check0 ;

M: blake2b-state get-checksum
    dup output>> [
        dup state>> [
            over output-size>> [ <byte-array> ] keep
            [ blake2b_final check0 ] 2keep drop
        ] [ B{ } clone ] if*
        [ >>output ] keep
    ] unless* nip ;
