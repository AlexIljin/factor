USING: arrays kernel math strings unicode unicode.case ;
IN: talks.emerging-langs-talk.acme.frobnicate

GENERIC: my-generic ( x -- y )

M: integer my-generic dup * ;

M: string my-generic >upper ;

M: object my-generic dup 2array ;
