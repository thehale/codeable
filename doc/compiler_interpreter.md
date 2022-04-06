# Compiler and Interpreter Breakdown

## Compiler
Compiler transforms code written in a high-level programming language into the machine code, at once, before program runs.
* Compiler displays all errors after compilation

### Compiler Options

### Compiler Pros
* Compiled code runs faster
  * Offers easy syntax validation before runtime.


### Compiler Cons

## Interpreter
Interpreter converts each high-level program statement, one by one, into the machine code, during program run.
Interpreter displays errors of each line one by one
### Interpreter Optons

### Interpreter Pros
* Interpreters are easier to use
  * Line by line analysis provides low level of complexity to small operations, not great for function calls

### Interpreter Cons
* Interpreted code runs slower

# Discussion
* With prolog as our interpreter, we can take our grammar / code form, line by line, and feed our parse tree responses back to our primary compiler.
    * In order to do this, we must set a DCG parse tree predicate in prolog, as well as a intermediate compiler on our front side, which can be in any higher    level language.
* The team has elected to use prolog for our interpreter, and this will take a tokenized input from our language, and return a parse tree to the compiler.
