! Copyright (C) 2015 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
! http://rosettacode.org/wiki/Seven-sided_dice_from_five-sided_dice
! http://rosettacode.org/wiki/Simple_Random_Distribution_Checker
USING: kernel random math math.functions math.vectors sequences locals prettyprint ;
IN: dice7

! Output a random number 1..5.
: dice5 ( -- x )
   random-unit 5 * floor 1 + >integer
;

! Output a random number 1..7 using dice5 as randomness source.
: dice7 ( -- x )
   0 [ dup 21 < ] [ drop dice5 5 * dice5 + 6 - ] do until
   7 rem 1 + >integer
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
! the total count. Rnd-func is a word that produces a random number on stack,
! times is the number of times to call it.
! Sample call: 0.02 7 \ dice7 100000 verify
:: verify ( delta sides rnd-func: ( -- random ) times -- )
   rnd-func times roll
   sides count-diceX-outcomes
   times sides / :> ideal-count
   ideal-count v-n vabs
   times v/n
   delta [ > ] curry map
   vall? [ "Random enough" . ] [ "Not random enough" . ] if
;


! Same as verify, but without named locals, just stack shuffling.
! refresh-all 0.002 100000 7 / \ dice7 100000 verify-u
: verify-u ( delta ideal rnd-func: ( -- random ) times -- )
   [ roll ] keep swap
   7 count-diceX-outcomes
   rot v-n vabs
   swap v/n
   swap [ > ] curry map
   vall? [ "Random enough" . ] [ "Not random enough" . ] if
;
