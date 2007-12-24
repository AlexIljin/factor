! Copyright (c) 2007 Aaron Schaefer.
! See http://factorcode.org/license.txt for BSD license.
USING: calendar combinators.lib kernel math namespaces ;
IN: project-euler.019

! http://projecteuler.net/index.php?section=problems&id=19

! DESCRIPTION
! -----------

! You are given the following information, but you may prefer to do some
! research for yourself.

!     * 1 Jan 1900 was a Monday.
!     * Thirty days has September, April, June and November.  All the rest have
!       thirty-one, Saving February alone, Which has twenty-eight, rain or
!       shine.  And on leap years, twenty-nine.
!     * A leap year occurs on any year evenly divisible by 4, but not on a
!       century unless it is divisible by 400.

! How many Sundays fell on the first of the month during the twentieth century
! (1 Jan 1901 to 31 Dec 2000)?


! SOLUTION
! --------

<PRIVATE

: start-date ( -- timestamp )
    1901 1 1 0 0 0 0 make-timestamp ;

: end-date ( -- timestamp )
    2000 12 31 0 0 0 0 make-timestamp ;

: (first-days) ( end-date start-date -- )
    2dup timestamp- 0 >= [
        dup day-of-week , 1 +month (first-days)
    ] [
        2drop
    ] if ;

: first-days ( start-date end-date -- seq )
    [ swap (first-days) ] { } make ;

PRIVATE>

: euler019 ( -- answer )
    start-date end-date first-days [ zero? ] count ;

! [ euler019 ] 100 ave-time
! 131 ms run / 3 ms GC ave time - 100 trials

MAIN: euler019
