USING: arrays kernel random sequences ;
IN: crash-factor

: 1hash ( bytes -- hash ) length random-bytes ;
: 5hash ( bytes -- h h h h h ) 1hash dup 1hash dup 1hash dup 1hash dup 1hash ;
: hashes ( seed -- seed' seq ) 300000 iota [ drop 5hash [ 4array ] dip swap ] map ;
: crash ( -- h h h h h h ) 40 random-bytes hashes swap hashes swap hashes swap hashes swap hashes ;
