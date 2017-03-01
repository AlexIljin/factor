! Copyright (C) 2017 John Benediktsson.
USING: accessors arrays effects kernel sequences vocabs ;

IN: help-search

: effect-in-names ( effect -- names )
    in>> [ dup pair? [ first ] when ] map ;

: effect-out-names ( effect -- names )
    out>> [ dup pair? [ first ] when ] map ;

: effect-names ( effect -- {in,out} )
    [ effect-in-names ] [ effect-out-names ] bi 2array ;

: search-for-effect ( effect -- words )
    effect-names all-words [ stack-effect effect-names = ] with filter ;
