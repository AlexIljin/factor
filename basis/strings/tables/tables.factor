! Copyright (C) 2009, 2010 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: ascii fry kernel math.order math.ranges sequences
splitting ;
IN: strings.tables

<PRIVATE

: format-row ( seq -- seq )
    dup longest length '[ _ "" pad-tail ] map! ;

: pad-column ( str n -- str' )
    CHAR: \s pick ?first [ digit? ] [ f ] if*
    [ pad-head ] [ pad-tail ] if ;

: format-column ( seq -- seq )
    dup longest length '[ _ pad-column ] map! ;

PRIVATE>

: format-table ( table -- seq )
    [ [ string-lines ] map format-row flip ] map concat flip
    [ { } ] [
        [ but-last-slice [ format-column ] map! drop ] keep
        flip [ " " join ] map!
    ] if-empty ;
