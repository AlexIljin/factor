! Copyright (C) 2015 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
! http://rosettacode.org/wiki/Seven-sided_dice_from_five-sided_dice
! http://rosettacode.org/wiki/Simple_Random_Distribution_Checker
USING: kernel random math math.functions sequences locals prettyprint ;
IN: dice7

! Output a random number 1..5.
: dice5 ( -- x )
   random-unit 5 * floor 1 + >integer ;

! Output a random number 1..7 using dice5 as randomness source.
: dice7 ( -- x )
   0 [ dup 21 < ] [ drop dice5 5 * dice5 + 6 - ] do until
   7 rem 1 + >integer ;

! Test uniformity of the distribution for an array of 1000000 dice7 rolls.

: assert-empty ( seq -- ) length 0 assert= ;

: roll-dice5 ( times -- array ) iota [ drop dice5 ] map ;

: roll-dice7 ( times -- array ) iota [ drop dice7 ] map ;

:: count-and-remove ( array elt -- array' num-removed )
   array length :> length-before
   elt array remove-eq
   dup length length-before - neg
;

: count-dice7-outcomes-v1 ( array -- array )
   dup length swap
   7 iota [ 1 + count-and-remove ] map
   swap assert-empty
   dup sum rot assert=
;

! Input array contains outcomes of a number of die throws. Each die result is
! an integer in the range 1..X. Calculate and return the number of each
! of the results in the array so that in the first position of the result
! there is the number of ones in the input array, in the second position
! of the result there is the number of twos in the input array, etc.
: count-diceX-outcomes ( array X -- array )
   iota [ 1 + dupd [ = ] curry count ] map
   swap length
   over sum
   assert=
;

: count-dice7-outcomes ( array -- array )
   7 count-diceX-outcomes
;
