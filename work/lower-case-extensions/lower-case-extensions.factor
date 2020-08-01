! Copyright (C) 2019 Alexander Ilin.
USING:
    formatting
    io.directories io.directories.search io.encodings.utf8 io.files
    io.pathnames kernel math namespaces sequences unicode
;

IN: lower-case-extensions

: except-.git ( seq -- seq' )
    [ "/.git/" swap subseq? ] reject ; inline

: (lower-case-extensions) ( path -- )
    [ dup length swap last path-separator? [ 1 + ] unless ] keep
    recursive-directory-files except-.git [
        over tail dup [ parent-directory ] [ file-stem ] [ file-extension ] tri [
            dup >lower 2dup = [ 5drop ] [
                nip "git mv -f %s %s%s.%s\r\n" printf
            ] if
        ] [ 3drop ] if*
    ] each drop ;

: lower-case-extensions ( path batch-file-name -- )
    utf8 [ (lower-case-extensions) ] with-file-writer ;

: run-in-current-directory ( -- )
    current-directory get "lower-case-extensions.cmd"
    lower-case-extensions ;

MAIN: run-in-current-directory
