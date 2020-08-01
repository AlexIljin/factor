! Copyright (C) 2020 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING:
    clip kernel sequences totp
;

IN: totp-clip

: totp-clip ( seed-string -- )
    [ CHAR: space = ] reject totp >clip ;
