IN: http.server.sessions.tests
USING: tools.test http http.server.sessions
http.server.sessions.storage http.server.sessions.storage.db
http.server.actions http.server math namespaces kernel accessors
prettyprint io.streams.string io.files splitting destructors
sequences db db.sqlite continuations ;

: with-session
    [
        >r [ save-session-after ] [ \ session set ] bi r> call
    ] with-destructors ; inline

TUPLE: foo ;

C: <foo> foo

M: foo init-session* drop 0 "x" sset ;

M: foo call-responder*
    2drop
    "x" [ 1+ ] schange
    "text/html" <content> [ "x" sget pprint ] >>body ;

: url-responder-mock-test
    [
        <request>
            "GET" >>method
            "id" get session-id-key set-query-param
            "/" >>path
        request set
        { } session-manager get call-responder
        [ write-response-body drop ] with-string-writer
    ] with-destructors ;

: session-manager-mock-test
    [
        <request>
            "GET" >>method
            "cookies" get >>cookies
            "/" >>path
        request set
        { } session-manager get call-responder
        [ write-response-body drop ] with-string-writer
    ] with-destructors ;

: <exiting-action>
    <action>
        [
            "text/plain" <content> exit-with
        ] >>display ;

[ "auth-test.db" temp-file sqlite-db delete-file ] ignore-errors

"auth-test.db" temp-file sqlite-db [

    init-request
    init-sessions-table

    [ ] [
        <foo> <session-manager>
            sessions-in-db >>sessions
        session-manager set
    ] unit-test

    [
        empty-session
            123 >>id session set

        [ ] [ 3 "x" sset ] unit-test

        [ 9 ] [ "x" sget sq ] unit-test

        [ ] [ "x" [ 1- ] schange ] unit-test

        [ 4 ] [ "x" sget sq ] unit-test

        [ t ] [ session get changed?>> ] unit-test
    ] with-scope

    [ t ] [
        session-manager get begin-session id>>
        session-manager get sessions>> get-session session?
    ] unit-test

    [ { 5 0 } ] [
        [
            session-manager get begin-session
            dup [ 5 "a" sset ] with-session
            dup [ "a" sget , ] with-session
            dup [ "x" sget , ] with-session
            id>> session-manager get sessions>> delete-session
        ] { } make
    ] unit-test

    [ 0 ] [
        session-manager get begin-session id>>
        session-manager get sessions>> get-session [ "x" sget ] with-session
    ] unit-test

    [ { 5 0 } ] [
        [
            session-manager get begin-session id>>
            dup session-manager get sessions>> get-session [ 5 "a" sset ] with-session
            dup session-manager get sessions>> get-session [ "a" sget , ] with-session
            dup session-manager get sessions>> get-session [ "x" sget , ] with-session
            session-manager get sessions>> delete-session
        ] { } make
    ] unit-test

    [ ] [
        <foo> <session-manager>
            sessions-in-db >>sessions
        session-manager set
    ] unit-test

    [
        <request>
        "GET" >>method
        "/" >>path
        request set
        { "etc" } session-manager get call-responder response set
        [ "1" ] [ [ response get write-response-body drop ] with-string-writer ] unit-test
        response get
    ] with-destructors
    response set

    [ ] [ response get cookies>> "cookies" set ] unit-test

    [ "2" ] [ session-manager-mock-test ] unit-test
    [ "3" ] [ session-manager-mock-test ] unit-test
    [ "4" ] [ session-manager-mock-test ] unit-test

    [
        [ ] [
            <request>
                "GET" >>method
                "id" get session-id-key set-query-param
                "/" >>path
            request set

            [
                { } <exiting-action> <session-manager>
                    sessions-in-db >>sessions
                call-responder
            ] with-destructors response set
        ] unit-test

        [ "text/plain" ] [ response get "content-type" header ] unit-test

        [ f ] [ response get cookies>> empty? ] unit-test
    ] with-scope
] with-db
