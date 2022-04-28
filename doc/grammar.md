// Initial Definitions
`identifier` := \w+(-\w+)*
`identifier_answer` := answer
`identifier_answer` := no-answer


`block` := `assignment` \n
`block` := `assignment` \n `block`
`block` := `print_statement` \n
`block` := `print_statement` \n `block`

// Requirement 1a
`boolean` := true
`boolean` := false
`expression_boolean` := `expression_boolean` and `expression_boolean`
`expression_boolean` := `expression_boolean` or `expression_boolean`
`expression_boolean` := not `expression_boolean`

// Requirement 1b
`number` := [0-9]+(\.[0-9]+)?

`expression` := `number`
`expression` := `boolean`
`expression` := `string`
`expression` := `identifier`
`expression` := `ternary`
`expression` := `function_call`
`expression` := `expression` plus `expression` 
`expression` := `expression` minus `expression` 
`expression` := `expression` times `expression` 
`expression` := `expression` divided-by `expression` 

// Requirement 1c
`word` := `identifier`
`word` := `identifier` `word`
`string` := < `word` >

// Requirement 2
`assignment` := `identifier` stores `expression`
`assignment_answer` := `identifier_answer` stores `expression`

// Requirement 3a
`ternary` := `expression` if `expression_boolean` otherwise `expression`

// Requirement 3b
`if_statement` := if `expression_boolean` \n `block` \n move-on
`if_statement` := if `expression_boolean` \n `block` \n otherwise \n `block` \n move-on
`if_statement` := if `expression_boolean` \n `block` \n otherwise `if_statement` \n move-on

// Requirement 4a
`loop_for` := for `identifier` from `identifer` \n `block` \n repeat

// Requirement 4b
`loop_while` := while `expression_boolean` \n `block` \n repeat

// Requirement 4c
// TODO - I'm thinking that "range(2,5)" could be a function that returns an iterable collection. That's how Python does it...

// Requirement 5
`print_statement` := show `identifier`

// Other Features: Functions
`argument` := `identifier`
`argument_list` := `argument`
`argument_list` := `argument` with `argument_list`

`function_definition` := `identifier` needs `argument_list` \n `block` \n `assignment_answer` \n

`function_call` := `identifier` of `argument_list`

// Other Features: Comments
`comment` := fyi `string` \n

// Comparison Operators
`greater_than` := `expression` is-greater-than `expression` 
`less_than` := `expression` is-less-than `expression` 
`equal-to` := `expression` is-equal-to `expression` 

