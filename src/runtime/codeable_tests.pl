/**
 * Copyright (c) 2022 Rithvik Arun, Joseph Hale, Jacob Hreshchyshyn, Jacob Janes, Sai Nishanth Vaka
 * 
 * This software is released under the MIT License.
 * https://opensource.org/licenses/MIT
 */

/**
 * Purpose: Unit tests for small portions of the Codeable interpreter
 * Date: 29 Apr 2022
 * Version: 0.1.0
 */

:- begin_tests(codeable).
:- include("codeable.pl").


test("show numeric parses correctly") :-
    program(ParseTree, [show, 25], []),
    ParseTree = prog(show_numeric(25)).

test("show string parses correctly") :-
    program(ParseTree, [show, <, hello, world, >], []),
    ParseTree = prog(show_string(str('hello world'))).

test("assignment parses correctly") :-
    assignment(ParseTree, [a, stores, -2], []),
    ParseTree = assign(a, expr_term(term_factor(factor_numeric(-2)))).

test("comments parse correctly") :-
    comment(ParseTree, [fyi, <, this, is, a, comment, >], []),
    ParseTree = fyi(str('this is a comment')).

test("exponentiation parses correctly") :-
    program(ParseTree, [a, stores, 2, raised, to, 3], []),
    ParseTree = prog(assign(a, expr_term(term_exponent(factor_numeric(2), factor_numeric(3))))).

test("is less than parses correctly") :-
    boolean(ParseTree, [1, is, less, than, 2], []),
    ParseTree = is_less_than(expr_term(term_factor(factor_numeric(1))), expr_term(term_factor(factor_numeric(2)))).

test("is greater than parses correctly") :-
    boolean(ParseTree, [3, is, greater, than, 2], []),
    ParseTree = is_greater_than(expr_term(term_factor(factor_numeric(3))), expr_term(term_factor(factor_numeric(2)))).

test("divided by parses correctly") :-
    program(ParseTree, [a, stores, 6, divided, by, 3], []),
    ParseTree = prog(assign(a, expr_term(term_divide(factor_numeric(6), term_factor(factor_numeric(3)))))).

test("move on parses correctly") :-
    program(ParseTree, [if, true, show, 1, move, on], []),
    ParseTree = prog(if(true, show_numeric(1), fyi(no_op))).

test("for loop parses correctly") :-
    program(ParseTree, [for, i, from, 0, to, 10, by, 1, show, i, repeat], []),
    ParseTree = 

:- end_tests(codeable).
