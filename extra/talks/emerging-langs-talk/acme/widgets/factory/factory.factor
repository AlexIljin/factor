! Copyright (C) 2010 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: combinators io kernel math namespaces
talks.emerging-langs-talk.acme.widgets.supply ;
IN: talks.emerging-langs-talk.acme.widgets.factory

SYMBOL: widgets

40 widgets set-global

: build-stuff ( -- )
    widgets [ 10 - ] change ;

: check-widget-supply ( -- )
    {
        { [ widgets get 20 < ] [ 20 send-widget-order ] }
        [ "Widgets are fully stocked" print ]
    } cond ;
