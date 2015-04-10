! Copyright (C) 2015 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel random math math.functions math.vectors math.ranges sequences locals prettyprint ;
IN: rosetta-code.dice7

! http://rosettacode.org/wiki/Seven-sided_dice_from_five-sided_dice
! http://rosettacode.org/wiki/Simple_Random_Distribution_Checker

! Output a random integer 1..5.
: dice5 ( -- x )
   5 [1,b] random
;

! Output a random integer 1..7 using dice5 as randomness source.
: dice7 ( -- x )
   0 [ dup 21 < ] [ drop dice5 5 * dice5 + 6 - ] do until
   7 rem 1 +
;

! Roll dice using the passed word the given number of times and produce an
! array with roll results.
! Sample call: \ dice7 1000 roll
: roll ( word: ( -- x ) times -- array )
   iota [ drop dup execute( --  x ) ] map
   nip
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

! Verify distribution uniformity/Naive. Delta is the acceptable deviation
! from the ideal number of items in each bucket, expressed as a fraction of
! the total count. Sides is the number of die sides. Rnd-func is a word that
! produces a random number on stack in the range [1..sides], times is the
! number of times to call it.
! Sample call: 0.02 7 \ dice7 100000 verify
:: verify ( delta sides rnd-func: ( -- random ) times -- )
   rnd-func times roll
   sides count-diceX-outcomes
   dup .
   times sides / :> ideal-count
   ideal-count v-n vabs
   times v/n
   delta [ < ] curry all?
   [ "Random enough" . ] [ "Not random enough" . ] if
;


! Call verify with 1, 10, 100, ... 1000000 rolls of 7-sided die.
: verify-all ( -- )
   { 1 10 100 1000 10000 100000 1000000 }
   [| times | 0.02 7 \ dice7 times verify ] each
;
