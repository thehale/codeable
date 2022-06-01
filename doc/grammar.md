<!--
 Copyright (c) 2022 Rithvik Arun, Joseph Hale, Jacob Hreshchyshyn, Jacob Janes, Sai Nishanth Vaka
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

// Initial Definitions
`identifier` := \w+

`command` := `comment`
`command` := `assignment`
`command` := `loop`
`command` := `show`
`command` := `selection`
`command` := `command` `command`

`program` := `command`


// Requirement 1a
`boolean` := true
`boolean` := false
`boolean` := not `boolean`
`boolean` := `expression` and `expression`
`boolean` := `expression` or `expression`
`boolean` := `expression` is_greater_than `expression`
`boolean` := `expression` is_less_than `expression`
`boolean` := `expression` equals `expression`

// Requirement 1b
`number` := [0-9]+(\.[0-9]+)?

`expression` := `number`
`expression` := `identifier`
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
`assignment` := `identifier` stores `string`
`assignment` := `identifier` stores `ternary`

// Requirement 3a
`ternary` := `expression` if `boolean` otherwise `expression`

// Requirement 3b
`if_statement` := if `boolean` `command` move-on
`if_statement` := if `boolean` `command` otherwise `command` move-on

// Requirement 4a
`loop_for` := for `identifier` from `expression` to `expression` by `expression` `command` repeat

// Requirement 4b
`loop_while` := while `boolean` `command` repeat

// Requirement 4c
`loop_for` := for `identifier` from `expression` to `expression` `command` repeat

// Requirement 5
`print` := show `string`
`print` := show `number`
`print` := show `identifier`

// Other Features: Comments
`comment` := fyi `string` \n
