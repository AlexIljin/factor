! Copyright (C) 2019 Alexander Ilin.
USING:
    clip io kernel random.passwords
;

IN: new-pass

: new-pass ( -- )
    64 ascii-password dup >clip print
    "The password is copied to the Clipboard." print ;

MAIN: new-pass
