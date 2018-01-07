! Copyright (C) 2018 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING: continuations destructors kernel namespaces threads
zeromq ;
IN: zeromq.node

TUPLE: zeromq-node context thread ;

: zmq-node ( -- zeromq-node/f )
    \ zmq-node get-global ;

<PRIVATE

: (node-loop) ( context -- )
    drop ;

PRIVATE>

: start-node ( -- )
    <zmq-context> dup [
        [
            [ (node-loop) ] [ f \ zmq-node set-global ] finally
        ] with-disposal
    ] curry "ZeroMQ polling node" spawn
    zeromq-node boa \ zmq-node set-global ;

! Start note, unless it is already running.
: ?start-node ( -- )
    zmq-node [ start-node ] unless ;
