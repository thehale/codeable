% Language: Codeable
% Authors: Jacob H, Jacob J, Joseph H, Rithvik A, Sai Nishanth V.
% Version: 0.5.20220423


% Main Parser
codeable(t_codeable(X)).

% Parser - Numercis
number(t_number(N)) --> [N], {number(N)}.

% Parser - Booleans
% boolean
boolean(t_bool_true) --> [true]. 
boolean(t_bool_false) --> [false].

% Boolean comparission
bool_expr(t_is_equal_to(X,Y)) --> expression(X), [is-equal-to], expression(Y).


% Parser - Assignment
expression(t_assign_exprmult(X,Y)) --> id(X), [equals], expression(Y). 
expression(X) --> expr(X).

% Parser - Functions

functions(t_functions(A,X,Y)) --> [begin], decl(X), [;], comm(Y), [end].

% Functions eval

function_eval(Id, Args, [(Id,t_codeable_functions(Pt))|_],Value).
function_eval(Id, Aegs, [_|T],Value) :- function_eval(Id, T, Value).


% Main evaluator
codeable_evaluator(t_codeable(Pt), R).