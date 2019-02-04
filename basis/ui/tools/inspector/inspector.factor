! Copyright (C) 2006, 2009 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors arrays assocs classes combinators fonts
formatting fry hashtables inspector io io.styles kernel math
math.parser math.vectors mirrors models models.arrow namespaces
prettyprint sequences sorting strings ui ui.commands ui.gadgets
ui.gadgets.labeled ui.gadgets.panes ui.gadgets.scrollers
ui.gadgets.status-bar ui.gadgets.tables
ui.gadgets.tables.private ui.gadgets.toolbar ui.gadgets.tracks
ui.gestures ui.operations ui.text ui.theme ui.tools.browser
ui.tools.common ui.tools.inspector.slots unicode ;
IN: ui.tools.inspector

TUPLE: inspector-gadget < tool table ;

TUPLE: slot-description key key-string value value-string ;

: <slot-description> ( key value -- slot-description )
    [ dup unparse-short ] bi@ slot-description boa ;

SINGLETON: inspector-renderer

M: inspector-renderer row-columns
    drop [ key-string>> ] [ value-string>> ] bi 2array ;

M: inspector-renderer row-value
    drop value>> ;

M: inspector-renderer column-titles
    drop { "Key" "Value" } ;

: <summary-gadget> ( model -- gadget )
    [
        standard-table-style [
            {
                [
                    [
                        [ "Class:" write ] with-cell
                        [ class-of pprint ] with-cell
                    ] with-row
                ]
                [
                    [
                        [ "Object:" write ] with-cell
                        [ pprint-short ] with-cell
                    ] with-row
                ]
                [
                    [
                        [ "Summary:" write ] with-cell
                        [ print-summary ] with-cell
                    ] with-row
                ]
                [
                    content-gadget [
                        [
                            [ "Content:" write ] with-cell
                            [ output-stream get write-gadget ] with-cell
                        ] with-row
                    ] when*
                ]
            } cleave
        ] tabular-output
    ] <pane-control> ;

GENERIC: make-slot-descriptions ( obj -- seq )

M: object make-slot-descriptions
    make-mirror [ <slot-description> ] { } assoc>map ;

M: string make-slot-descriptions
    [
        swap [ dup number>string ] dip dup
        dup printable? [
            dup 1string swap "%s   \\u{%x}" sprintf
        ] [
            dup 0xff <= [
                H{
                    { CHAR: \a "\\a  \\x07" }
                    { CHAR: \b "\\b  \\x08" }
                    { CHAR: \e "\\e  \\x1b" }
                    { CHAR: \f "\\f  \\x0c" }
                    { CHAR: \n "\\n  \\x0a" }
                    { CHAR: \r "\\r  \\x0d" }
                    { CHAR: \t "\\t  \\x09" }
                    { CHAR: \v "\\v  \\x0b" }
                    { CHAR: \0 "\\0  \\x00" }
                } ?at [ "    \\x%02x" sprintf ] unless
            ] [
                "\\u{%x}" sprintf
            ] if
        ] if slot-description boa
    ] map-index ;

M: hashtable make-slot-descriptions
    call-next-method [ key-string>> ] sort-with ;

! If model is an enumerated, get its maximum index, measure its width
! rendered in the table, and use that as the first column width (or
! the first column title width, whichever is greater). This
! improves performance when inspecting big arrays.
: first-column-width ( table model -- width )
    value>> make-mirror dup enumerated? [ length 1 - 1array ] [ keys ] if
    [ unparse-short ] map over renderer>> column-titles first suffix
    row-column-widths supremum ;

: fix-column-widths ( table model -- table )
    dupd first-column-width 0 2array >>fixed-column-widths ;

: <inspector-table> ( model -- table )
    dup [ make-slot-descriptions ] <arrow> inspector-renderer <table>
        [ invoke-primary-operation ] >>action
        line-color >>column-line-color
        monospace-font >>font
        6 >>gap
        15 >>min-rows
        15 >>max-rows
        40 >>min-cols
        40 >>max-cols
        swap fix-column-widths ;

: <inspector-gadget> ( model -- gadget )
    vertical inspector-gadget new-track with-lines
        add-toolbar
        swap >>model
        dup model>> <inspector-table> >>table
        dup model>> <summary-gadget> margins white-interior
        "Object" object-color <colored-labeled-gadget> f track-add
        dup table>> <scroller> margins white-interior
        "Contents" contents-color <colored-labeled-gadget> 1 track-add ;

M: inspector-gadget focusable-child*
    table>> ;

: com-refresh ( inspector -- )
    [ model>> notify-connections ] keep
    [ table>> ] [ model>> ] bi fix-column-widths drop ;

: com-push ( inspector -- obj )
    control-value ;

\ com-push H{ { +listener+ t } } define-command

: com-edit-slot ( inspector -- )
    [ close-window ] swap
    [ '[ _ com-refresh ] ]
    [ control-value make-mirror ]
    [ table>> (selected-row) ] tri [
        [ key>> ] [ key-string>> ] bi
        slot-editor-window
    ] [ 4drop ] if ;

: inspector-help ( -- ) "ui-inspector" com-browse ;

\ inspector-help H{ { +nullary+ t } } define-command

inspector-gadget "toolbar" f {
    { T{ key-down f f "r" } com-refresh }
    { T{ key-down f f "p" } com-push }
    { T{ key-down f f "e" } com-edit-slot }
    { T{ key-down f f "F1" } inspector-help }
} define-command-map

inspector-gadget "multi-touch" f {
    { up-action com-refresh }
} define-command-map

: inspect-model ( model -- )
    <inspector-gadget> "Inspector" open-status-window ;

: inspector ( obj -- )
    <model> inspect-model ;

inspector-gadget default-font-size { 46 33 } n*v set-tool-dim
