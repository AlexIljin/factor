! Copyright (C) 2012 Alex Vondrak.
USING: assocs fry io io.encodings.utf8 io.files kernel
path-finding regexp sequences splitting tools.crossref vocabs
vocabs.hierarchy vocabs.loader ;

IN: circular-dependencies

: vocab-source-code ( vocab -- str )
    vocab-source-path [ utf8 file-contents ] [ "" ] if* ;

: using-line ( source -- vocabs )
    R/ USING: [^;]* ;/s all-matching-subseqs ?first
    [ { } ] [ " \n" split rest but-last ] if-empty ;

: vocab-using ( vocab -- vocabs )
    ! Doesn't necessarily get 100% of the dependencies, but
    ! avoids having to load the vocab.
    vocab-source-code using-line ;

: dependencies ( vocab -- vocabs )
    dup lookup-vocab [ vocab-uses ] [ vocab-using ] if ;

: dependency-graph ( vocabs -- graph )
    H{ } clone [
        '[ [ dependencies ] keep _ set-at ] each
    ] keep ;

: circularities ( vocabs -- cycles )
    ! cycles is an assoc mapping each vocab v to a sequence of
    ! paths from v's uses back to v.
    dependency-graph dup <bfs> '[
        dupd [ swap _ find-path ] with map sift
    ] assoc-map ;

: (circularities.) ( vocab path -- )
    ", which uses " join " uses " glue print ;

: circularities. ( vocabs -- )
    circularities [
        [ drop ] [ [ (circularities.) ] with each ] if-empty
    ] assoc-each ;

: all-circularities. ( -- )
    all-disk-vocab-names filter-vocabs [ vocab-name ] map! circularities. ;
