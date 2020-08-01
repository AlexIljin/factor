! Copyright (C) 2020 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING:
    io.launcher kernel
;

IN: cmd

: c ( -- ) "c.bat" run-detached drop ;
: g ( -- ) "g.bat" run-detached drop ;
