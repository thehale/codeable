:- begin_tests(codeable).
:- include("codeable.pl").


test('`show 25` parses correctly') :-
    program(P, [show, 25], []),
    P = prog(show_numeric(25)).

test('`show < hello world >` parses correctly') :-
    program(P, [show, <, hello, world, >], []),
    P = prog(show_string('hello world')).

:- end_tests(codeable).
