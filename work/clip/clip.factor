! Copyright (C) 2020 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING:
    namespaces ui.clipboards
;

IN: clip

: >clip ( string -- )
    clipboard get set-clipboard-contents ;

: clip> ( -- string )
    clipboard get clipboard-contents ;
