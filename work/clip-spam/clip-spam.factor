! Copyright (C) 2020 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING:
    calendar clip continuations kernel namespaces
    random random.passwords
    threads
;

IN: clip-spam

: main ( -- )
    [
        random-generator get-global secure-random-generator set-global [
            [ 64 ascii-password >clip 100 milliseconds sleep ]
            [ drop ] recover t
        ] loop
    ] "Clipboard Spammer" spawn drop ;

MAIN: main
