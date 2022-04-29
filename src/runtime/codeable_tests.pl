:- begin_tests(codeable).
:- include("codeable.pl").


test("show numeric parses correctly") :-
    program(ParseTree, [show, 25], []),
    ParseTree = prog(show_numeric(25)).

test("show string parses correctly") :-
    program(ParseTree, [show, <, hello, world, >], []),
    ParseTree = prog(show_string('hello world')).

test("assignment parses correctly") :-
    assignment(ParseTree, [a, stores, -2], []),
    ParseTree = assign(id(a), expr_term(term_factor(factor_numeric(-2)))).

test("comments parse correctly") :-
    comment(ParseTree, [fyi, <, this, is, a, comment, >], []),
    ParseTree = fyi('this is a comment').

test("exponentiation parses correctly") :-
    program(ParseTree, [a, stores, 2, raised-to, 3], []),
    ParseTree = prog(assign(id(a), expr_term(term_exponent(factor_numeric(2), factor_numeric(3))))).

test("for loop parses correctly") :-
    program(ParseTree, [for, i, from, 0, to, 10, by, 1, show, i, repeat], []),
    ParseTree = 

:- end_tests(codeable).
