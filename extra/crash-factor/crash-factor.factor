USING: arrays checksums checksums.openssl kernel sequences ;
IN: crash-factor

: 1hash ( bytes -- hash ) openssl-sha1 checksum-bytes ;
: 5hash ( bytes -- h h h h h ) 1hash dup 1hash dup 1hash dup 1hash dup 1hash ;
: hashes ( seed -- seed' seq ) 300000 iota [ drop 5hash [ 4array ] dip swap ] map ;
: crash ( -- h h h h h h ) B{ } hashes swap hashes swap hashes swap hashes swap hashes ;
