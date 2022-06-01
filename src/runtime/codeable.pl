/**
 * Copyright (c) 2022 Rithvik Arun, Joseph Hale, Jacob Hreshchyshyn, Jacob Janes, Sai Nishanth Vaka
 * 
 * This software is released under the MIT License.
 * https://opensource.org/licenses/MIT
 */

/**
 * Purpose: Interpreter for Codeable code.
 * Date: 29 Apr 2022
 * Version: 0.1.0
 */

% :- use_rendering(svgtree).  % Only works in SWISH.swi-prolog.org

/**
 * codeable_version(-Major,-Minor,-Patch) is det.
 */
codeable_version(0,0,1).

/**
 * Token Parser
 */
numeric(N) --> [N], {number(N)}.

identifier(I) --> [I], {atom(I)}.

word([W]) --> identifier(W).
word([W1 | W2]) --> [W1], word(W2), { atom(W1), W1 \= <, W1 \= > }.
strings(str(S)) --> [<], word(W), [>], { atomic_list_concat(W, ' ', S) }.

comment(fyi(S)) --> [fyi], strings(S).

factor(factor_numeric(F)) --> numeric(F).
factor(factor_identifier(F)) --> identifier(F).
factor(factor_expression(F)) --> ['('], expr(F), [')'].

sub_term(term_factor(T)) --> factor(T).
sub_term(term_exponent(F1, F2)) --> factor(F1), [raised_to], factor(F2).

term(T) --> sub_term(T).
term(term_times(T1, T2)) --> factor(T1), [times],  term(T2).
term(term_divide(T1, T2)) -->  factor(T1), [divided_by], term(T2).

expr(expr_term(E)) --> term(E).
expr(expr_plus(E1, E2)) --> term(E1), [plus],  expr(E2).
expr(expr_minus(E1, E2)) --> term(E1), [minus],  expr(E2).

boolean(true) --> [true].
boolean(false) --> [false].
boolean(not(B)) --> [not], boolean(B).
boolean(equals(E1, E2)) --> expr(E1), [equals], expr(E2).
boolean(is_greater_than(E1, E2)) --> expr(E1), [is_greater_than], expr(E2).
boolean(is_less_than(E1, E2)) --> expr(E1), [is_less_than], expr(E2).

assignment(assign(I, E)) --> identifier(I), [stores], expr(E).
assignment(assign(I, E)) --> identifier(I), [stores], strings(E).
assignment(assign(I, E)) --> identifier(I), [stores], selection_inline(E).

selection(if(B, C, fyi(no_op))) --> [if], boolean(B), command(C), [move_on].
selection(if(B, C1, C2)) --> [if], boolean(B), command(C1), [otherwise], command(C2), [move_on].
selection_inline(ternary(B, T, F)) --> expr(T), [if], boolean(B), [otherwise], expr(F).

loop(for(I, Start, Stop, Step, C)) --> [for], identifier(I), [from], expr(Start), [to], expr(Stop), [by], expr(Step), command(C), [repeat].
loop(for(I, Start, Stop, expr_term(term_factor(factor_numeric(1))), C)) --> [for], identifier(I), [from], expr(Start), [to], expr(Stop), command(C), [repeat].

loop(while(B, C)) --> [while], boolean(B), command(C), [repeat].

show(show_string(S)) --> [show], strings(S).
show(show_numeric(D)) --> [show], numeric(D).
show(show_identifier(I)) --> [show], identifier(I).

command(cmd(C1, C2)) --> comment(C1), command(C2).
command(cmd(C1, C2)) --> assignment(C1), command(C2).
command(cmd(C1, C2)) --> loop(C1), command(C2).
command(cmd(C1, C2)) --> show(C1), command(C2).
command(cmd(C1, C2)) --> selection(C1), command(C2).
command(C) --> comment(C).
command(C) --> assignment(C).
command(C) --> loop(C).
command(C) --> show(C).
command(C) --> selection(C).

program(prog(P)) --> command(P).

/**
 * eval(+Node, +EnvIn, -EnvOut, -ValueOut)
 * 
 * Evaluates the parse tree rooted at Node, with the environment EnvIn,
 * and returns the environment EnvOut and the value ValueOut.
 *
 * The environment is a list of pairs (Identifier, Value) where Identifier
 * is a string and Value is an integer.
 * 
 */ 
eval(prog(P), EnvIn, EnvOut, ValueOut) :-
    eval(P, EnvIn, EnvOut, ValueOut).

eval(fyi(S), EnvIn, EnvIn, S).

eval(str(S), EnvIn, EnvIn, S).

eval(cmd(C1, C2), EnvIn, EnvOut, ValueOut) :-
    eval(C1, EnvIn, EnvTemp, _ValueOut),
    eval(C2, EnvTemp, EnvOut, ValueOut).

eval(assign(I, E), EnvIn, EnvOut, ValueOut) :-
    eval(E, EnvIn, EnvTemp, ValueOut),
    update(I, ValueOut, EnvTemp, EnvOut).

eval(if(B, T, _), EnvIn, EnvOut, ValueOut) :-
    eval(B, EnvIn, EnvTemp, true),
    eval(T, EnvTemp, EnvOut, ValueOut).
eval(if(B, _, F), EnvIn, EnvOut, ValueOut) :-
    eval(B, EnvIn, EnvTemp, false),
    eval(F, EnvTemp, EnvOut, ValueOut).
eval(ternary(B, T, F), EnvIn, EnvOut, ValueOut) :-
    eval(if(B, T, F), EnvIn, EnvOut, ValueOut).

eval(while(B, C), EnvIn, EnvOut, ValueOut) :-
    eval(B, EnvIn, EnvTemp, true),
    eval(C, EnvTemp, EnvTemp2, _ValueOut),
    eval(while(B, C), EnvTemp2, EnvOut, ValueOut).
eval(while(B, _), EnvIn, EnvOut, _ValueOut) :-
    eval(B, EnvIn, EnvOut, false).

eval(for(I, Start, Stop, Step, C), EnvIn, EnvOut, ValueOut) :-
    eval(is_less_than(Start, Stop), EnvIn, EnvTemp, true),
    eval(Start, EnvTemp, EnvTemp1, ValueStart), 
    update(I, ValueStart, EnvTemp1, EnvTemp2),
    eval(C, EnvTemp2, EnvTemp3, _ValueOut),
    eval(Step, EnvTemp3, EnvTemp4, ValueStep),
    NextStart is ValueStart + ValueStep,
    eval(for(I, expr_term(term_factor(factor_numeric(NextStart))), Stop, Step, C), EnvTemp4, EnvOut, ValueOut).
eval(for(I, Start, Stop, _, _), EnvIn, EnvOut, _ValueOut) :-
    eval(Start, EnvIn, EnvTemp, ValueStart),
    update(I, ValueStart, EnvTemp, EnvTemp2),
    eval(is_less_than(Start, Stop), EnvTemp2, EnvOut, false).

eval(expr_plus(Term, Expression), EnvIn, EnvOut, ValueOut) :-
    eval(Term, EnvIn, EnvTemp, ValTerm),
    eval(Expression, EnvTemp, EnvOut, ValExpr),
    ValueOut is ValTerm + ValExpr.
eval(expr_minus(Term, Expression), EnvIn, EnvOut, ValueOut) :-
    eval(Term, EnvIn, EnvTemp, ValTerm),
    eval(Expression, EnvTemp, EnvOut, ValExpr),
    ValueOut is ValTerm + (0 - ValExpr).
eval(expr_term(T), EnvIn, EnvOut, ValueOut) :-
    eval(T, EnvIn, EnvOut, ValueOut).
eval(expr_assign(A), EnvIn, EnvOut, ValueOut) :-
    eval(A, EnvIn, EnvOut, ValueOut).

eval(term_exponent(Factor1, Factor2), EnvIn, Env2Out, ValueOut) :-
    eval(Factor1, EnvIn, Env1Out, Val1Out),
    eval(Factor2, Env1Out, Env2Out, Val2Out),
    ValueOut is Val1Out ** Val2Out.
eval(term_times(Factor, Term), EnvIn, Env2Out, ValueOut) :-
    eval(Factor, EnvIn, Env1Out, Val1Out),
    eval(Term, Env1Out, Env2Out, Val2Out),
    ValueOut is Val1Out * Val2Out.
eval(term_divide(Factor, Term), EnvIn, Env2Out, ValueOut) :-
    eval(Factor, EnvIn, Env1Out, Val1Out),
    eval(Term, Env1Out, Env2Out, Val2Out),
    ValueOut is Val1Out * (1 / Val2Out).
eval(term_factor(F), EnvIn, EnvOut, ValueOut) :-
    eval(F, EnvIn, EnvOut, ValueOut).

eval(factor_numeric(D), EnvIn, EnvIn, D).
eval(factor_identifier(I), EnvIn, EnvIn, Value) :-
    lookup(I, EnvIn, Value).
eval(factor_expression(E), EnvIn, EnvOut, Value) :-
    eval(E, EnvIn, EnvOut, Value).

eval(true, EnvIn, EnvIn, true).
eval(false, EnvIn, EnvIn, false).
eval(not(B), EnvIn, EnvOut, false) :-
    eval(B, EnvIn, EnvOut, true).
eval(not(B), EnvIn, EnvOut, true) :-
    eval(B, EnvIn, EnvOut, false).
eval(equals(E1, E2), EnvIn, EnvOut, true) :-
    eval(E1, EnvIn, EnvTemp, ValueOut),
    eval(E2, EnvTemp, EnvOut, ValueOut).
eval(equals(E1, E2), EnvIn, EnvOut, false) :-
    eval(E1, EnvIn, EnvTemp, ValueOut1),
    eval(E2, EnvTemp, EnvOut, ValueOut2),
    ValueOut1 =\= ValueOut2.
eval(is_less_than(E1, E2), EnvIn, EnvOut, true) :-
    eval(E1, EnvIn, EnvTemp, ValueOut1),
    eval(E2, EnvTemp, EnvOut, ValueOut2),
    ValueOut1 < ValueOut2.
eval(is_less_than(E1, E2), EnvIn, EnvOut, false) :-
    eval(E1, EnvIn, EnvTemp, ValueOut1),
    eval(E2, EnvTemp, EnvOut, ValueOut2),
    ValueOut1 >= ValueOut2.
eval(is_greater_than(E1, E2), EnvIn, EnvOut, true) :-
    eval(E1, EnvIn, EnvTemp, ValueOut1),
    eval(E2, EnvTemp, EnvOut, ValueOut2),
    ValueOut1 > ValueOut2.
eval(is_greater_than(E1, E2), EnvIn, EnvOut, false) :-
    eval(E1, EnvIn, EnvTemp, ValueOut1),
    eval(E2, EnvTemp, EnvOut, ValueOut2),
    ValueOut1 =< ValueOut2.

eval(show_char(C), EnvIn, EnvIn, _ValueOut) :-write([output, C]).
eval(show_string(str(S)), EnvIn, EnvIn, _ValueOut) :- write([output, S]).
eval(show_numeric(D), EnvIn, EnvIn, _ValueOut) :- write([output, D]).
eval(show_identifier(I), EnvIn, EnvIn, _ValueOut) :- 
    lookup(I, EnvIn, Value),
    write([output, Value]).

/**
 * lookup(+Identifier, +Env, -Value)
 * 
 * Looks up the Value of Identifier in Env.
 */
lookup(Identifier, [(Identifier, Value) | _], Value).
lookup(Identifier, [(OtherIdentifier, _) | RemainingEnvironment], Value) :-
    Identifier \= OtherIdentifier,
    lookup(Identifier, RemainingEnvironment, Value).

/**
 * update(+Identifier, +Value, +EnvIn, -EnvOut)
 * 
 * Updates the binding of Identifier in EnvIn to Value and returns EnvOut.
 */
update(Identifier, Value, [], [(Identifier, Value)]).
update(
    Identifier, 
    Value, 
    [(Identifier, _) | RemainingEnvironment], 
    [(Identifier, Value) | RemainingEnvironment]
).
update(
    Identifier,
    Value,
    [(OtherIdentifier, OtherValue) | RemainingEnvironment],
    [(OtherIdentifier, OtherValue) | NewEnvironment]
) :-
    Identifier \= OtherIdentifier,
    update(Identifier, Value, RemainingEnvironment, NewEnvironment).
