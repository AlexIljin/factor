! Copyright (C) 2018 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING: help.markup help.syntax kernel quotations threads ;
IN: zeromq.node

ABOUT: "zeromq.node"

ARTICLE: "zeromq.node" "ZeroMQ node"
"The " { $vocab-link "zeromq.node" } " vocab implements a ZeroMQ node as a green thread within the Factor's cooperative multitasking framework. It starts a thread that calls " { $snippet "zmq_poll" } " repeatedly and dispatches messages while there is anything to dispatch, then " { $link yield } "s to other threads."
$nl
"The tuple representing a ZeroMQ node:"
{ $subsections zeromq-node }
"Starting the global ZeroMQ node (you should normally only use one):"
{ $subsections ?start-node start-node }
"The currently running node, if any:"
{ $subsections zmq-node }
;

HELP: ?start-node
{ $description "Call " { $link start-node } ", unless the node is already running. Use this word to start the global ZeroMQ node." } ;

HELP: start-node
{ $description "Start the global ZeroMQ node without checking if it's already running or not. It is safer to use " { $link ?start-node } " instead." } ;

HELP: zmq-node
{ $values
    { "zeromq-node/f" "a " { $link zeromq-node } " or " { $link POSTPONE: f } }
}
{ $description "Returns the currently running " { $link zeromq-node } ", if any." } ;

{ ?start-node start-node zmq-node } related-words

HELP: try-finally
{ $values
    { "try-quot" quotation } { "finally-quot" quotation }
}
{ $description "A helper word that first calls the " { $snippet "try-quot" } " quotation, then the " { $snippet "finally-quot" } " quotation. The latter is called even if an exception was thrown in the " { $snippet "try-quot" } ", which is useful for any cleanup code that must always be executed." } ;

HELP: zeromq-node
{ $class-description "" } ;
