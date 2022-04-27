% :- use_rendering(svgtree).  % Only works in SWISH.swi-prolog.org


%%%%% Token Parser %%%%%%

% Parser - Numercis
number(t_number(N)) --> [N], {number(N)}.

% v3 (Heavily inspired by M2.1 - slide 59)
chars([X|Y]) --> char(X), chars(Y).
chars([]) --> [].

char(X) --> [X], { is_char(X) }.

string(X) --> ['\"'], char(X), ['\"'].
string(X) --> ['\"'], char(X), [' '], char(X), ['\"'].
string(X) --> ['\"'], char(X), [' '], string(X), ['\"'].

factor(factor_number(F)) --> number(F).
factor(factor_identifier(F)) --> identifier(F).
factor(factor_expression(F)) --> ['('], expr(F), [')'].

term(term_factor(T)) --> factor(T).
term(term_times(T1, T2)) --> [multiplication],[of], factor(T1), [with],  term(T2).
term(term_divide(T1, T2)) -->  [division],[of], factor(T1), [with], term(T2).

expr(expr_term(E)) --> term(E).
expr(expr_plus(E1, E2)) --> [addition], [of], term(E1), [with],  expr(E2).
expr(expr_minus(E1, E2)) --> [subtraction], [of], term(E1), [with],  expr(E2).
expr(expr_assign(A)) --> assignment(A).

boolean(true) --> [true].
boolean(false) --> [false].
boolean(not(B)) --> [not], boolean(B).
boolean(equals(E1, E2)) --> expr(E1), [is-equal-to], expr(E2).
boolean(is_greater_than(E1, E2)) --> expr(E1), [is-greater-than], expr(E2).
boolean(is_less_than(E1, E2)) --> expr(E1), [is-less-than], expr(E2).

assignment(assign(I, E)) --> identifier(I), [equals], expr(E).
ternary(if(B, T, F)) --> [if], boolean(B), [then], command(T), [else], command(F), [endif].
loop(while(B, C)) --> [while], boolean(B), command(C), [endwathile].
loop(for(I1, I2, C)) --> [for], identifier(I1), [from], identifier(I2), command(C), [repeat].

printC(print_char(C)) --> [printC], char(C).
printC(print_string(S)) --> [printC], string(S).
printC(print_digit(D)) --> [printC], digit(D).

command(C) --> assignment(C).
command(C) --> ternary(C).
command(C) --> loop(C).
command(C) --> block(C).
command(cmd(C1, C2)) --> assignment(C1), [;], command(C2).
command(cmd(C1, C2)) --> ternary(C1), [;], command(C2).
command(cmd(C1, C2)) --> loop(C1), [;], command(C2).
command(cmd(C1, C2)) --> block(C1), [;], command(C2).

constant(const(I, N)) --> [const], identifier(I), [=], digit(N).
variable(var(I)) --> [var], identifier(I).

declaration(D) --> constant(D).
declaration(D) --> variable(D).
declaration(decl(D1, D2)) --> constant(D1), [;], declaration(D2).
declaration(decl(D1, D2)) --> variable(D1), [;], declaration(D2).

block(blk(D, C)) --> [begin], declaration(D), [;], command(C), [end].

program(prog(P)) --> block(P), ['.'].

% Parser - Functions

functions(t_functions(Id, Args,Y, Val)) --> identifier(Id), decl_a1(Args), [needs], comm(Y), [answer], [equals], result(Val).

% Functions eval

function_eval(Id, Args, [(Id,t_codeable_functions(Pt))|_],Value).
function_eval(Id, Args, [_|T],Value) :- function_eval(Id, T, Value).

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

eval(blk(D, C), EnvIn, EnvOut, ValueOut) :-
    eval(D, EnvIn, EnvDecl, _ValueOut),
    eval(C, EnvDecl, EnvOut, ValueOut).

eval(var(I), EnvIn, EnvOut, _) :-
    declare(I, EnvIn, EnvOut).
eval(const(I, N), EnvIn, EnvOut, N) :-
    update(I, N, EnvIn, EnvOut).
eval(decl(D1, D2), EnvIn, EnvOut, ValueOut) :-
    eval(D1, EnvIn, EnvTemp, _ValueOut),
    eval(D2, EnvTemp, EnvOut, ValueOut).

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

eval(while(B, C), EnvIn, EnvOut, ValueOut) :-
    eval(B, EnvIn, EnvTemp, true),
    eval(C, EnvTemp, EnvTemp2, _ValueOut),
    eval(while(B, C), EnvTemp2, EnvOut, ValueOut).
eval(while(B, _), EnvIn, EnvOut, _ValueOut) :-
    eval(B, EnvIn, EnvOut, false).

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

eval(factor_digit(D), EnvIn, EnvIn, D).
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
 * declare(+Identifier, +EnvIn, -EnvOut)
 * 
 * Adds a new binding (Identifier, _) to EnvIn and returns EnvOut.
 *
 * If Identifier is already bound in EnvIn, it is not rebound.
 */
declare(Identifier, [], [(Identifier, _)]).
declare(
    Identifier,
    [(Identifier, Value) | RemainingEnvironment],
    [(Identifier, Value) | RemainingEnvironment]
).
declare(Identifier, [H | RemainingEnvironment], [H | NewEnvironment]) :-
    declare(Identifier, RemainingEnvironment, NewEnvironment).

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


/**
 * program_eval(+Program, +InitialX, +InitialY, -FinalZ)
 * 
 * Evaluates the Program with the initial value of X and Y 
 * and returns the final value of Z.
 */
program_eval(P, X, Y, Z) :-
    update(x, X, [], EnvX),
    update(y, Y, EnvX, EnvY),
    eval(P, EnvY, EnvOut, _ValueOut),
    lookup(z, EnvOut, Z).

digit(0) --> [0].
digit(1) --> [1].
digit(2) --> [2].
digit(3) --> [3].
digit(4) --> [4].
digit(5) --> [5].
digit(6) --> [6].
digit(7) --> [7].
digit(8) --> [8].
digit(9) --> [9].

identifier(WORD) --> { var(WORD), ! },
   chars(CHARS), { atom_codes(WORD, CHARS) }.
identifier(WORD) --> { nonvar(WORD) },
   { atom_codes(WORD, CHARS) }, chars(CHARS).

is_char(X) :- X >= 0'a, X =< 0'z, !.
is_char(X) :- X >= 0'A, X =< 0'Z, !.
is_char(X) :- X >= 0'0, X =< 0'9, !.
is_char(0'_).