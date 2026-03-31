// Copyright (c) 2022 Rithvik Arun, Joseph Hale, Jacob Hreshchyshyn, Jacob Janes, Sai Nishanth Vaka
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
 * Purpose: Interactivity for the browser based Codeable IDE
 * Date: 29 Apr 2022
 * Version: 0.1.0
 */

let INTERPRETER_CODE_PATH = "codeable.pl";
let LOADING_MSG = "Loading...";
let OUTPUT_LABEL = "Output";
let intermediateCode = "";

const EXAMPLES = {
  hello_world: {
    label: "Hello World",
    code: "greeting stores < hello world >\nshow greeting",
  },
  factorial: {
    label: "Factorial",
    code: `fyi < factorial >
fyi < example of while loop block >

n stores 4

value stores 1
temp stores n

while temp is_greater_than 1
    temp2 stores value
    value stores temp times temp2
    temp3 stores temp
    temp stores temp3 minus 1
repeat

show value`,
  },
  fibonacci: {
    label: "Fibonacci",
    code: `fyi < fibonacci >
fyi < example of if statements >

n stores 2

fib stores n minus 1 if n is_less_than 3 otherwise -1

if fib is_less_than 0

    iterator stores 1

    fyi < store the first two values of the fibonacci sequence >
    anteprev_n stores 0
    prev_n stores 1

    fyi < compute fibonacci numbers until n is reached >
    while iterator is_less_than n minus 1
        fib stores anteprev_n plus prev_n
        anteprev_n stores prev_n
        prev_n stores fib
        iterator stores iterator plus 1
    repeat

otherwise

    message stores < try a higher value of n for more fun >
    show message

move_on

show fib`,
  },
  quadratic_formula: {
    label: "Quadratic Formula",
    code: `fyi < quadratic formula >
a stores 1
b stores -2
c stores 1

b_squared stores b times b
four_a stores 4 times a
four_a_c stores four_a times c
discriminant stores b_squared minus four_a_c
sqrt_discriminant stores discriminant raised_to 0.5
negative_b stores 0 minus b
numerator stores negative_b plus sqrt_discriminant
denominator stores 2 times a
root stores numerator divided_by denominator

show root`,
  },
  range_count: {
    label: "Range Count",
    code: `fyi < rangeCount >
fyi < example usage of a for loop >

i stores 0
a stores 5

fyi < uses i as an iterator for a >
for i from 0 to a
    show i
repeat

for i from 0 to 10 by 2
    show i
repeat`,
  },
};

function populateCodeArea() {
  var codeArea = document.getElementById("code");
  codeArea.value = EXAMPLES.hello_world.code;
}

function registerExamplesListener() {
  var select = document.getElementById("examples");
  select.addEventListener("change", (event) => {
    var key = event.target.value;
    if (key && EXAMPLES[key]) {
      document.getElementById("code").value = EXAMPLES[key].code;
    }
  });
}

function hijackConsoleLog() {
  let consoleLog = console.log;
  console.log = (message) => {
    // debugger
    if (message.toString().indexOf("codeable_version") > 0) {
      consoleLog("[DEBUG] Capturing intermediate code");
      intermediateCode = message;
    }
    if (message.toString().indexOf("output") == 1) {
      consoleLog("[DEBUG] Capturing console output");
      let msg = message.toString().slice("[output,".length, -1);
      writeOutput(msg);
    }
    consoleLog(message);
  };
}

function prepareInterpreter() {
  console.log("[INFO] Preparing interpreter");
  let session = pl.create();

  session.consult(INTERPRETER_CODE_PATH, {
    success: () => {
      console.log("[INFO] Loaded interpreter source code");
      generateIntermediateCode(session);
    },
    error: (err) => console.log(err),
  });
}

function generateIntermediateCode(session) {
  session.query("listing.", {
    success: (goal) => patchIntermediateCode(session),
    error: function (err) {
      console.log(err);
      alert("[ERROR] Failed to generate intermediate parsing code");
    },
  });
}

function patchIntermediateCode(session) {
  session.answer({
    success: (answer) => {
      var patchedCode = intermediateCode
        .replace("[(|", "['('|")
        .replace("[)|", "[')'|")
        .replace(", ,", ",' ',");
      console.log(patchedCode);
    },
    error: (err) => {
      console.log(err);
      alert(
        "[ERROR] Failed to generate intermediate parsing code. The runtime will not work."
      );
    },
  });
}

function prepareComputation(callback) {
  document.getElementById("output-label").innerHTML = LOADING_MSG;
  writeOutput("", overwrite = true);
  setTimeout(() => {
    callback();
  }, 0)
}

function registerRunListener() {
  let runButton = document.getElementById("run");
  runButton.addEventListener("click", (el, ev) => {
    prepareComputation(() => {
      let session = pl.create();
      session.consult(intermediateCode, {
        success: () => {
          console.log("[INFO] Loaded interpreter source code");
          loadQuery(session);
        },
        error: (err) => {
          console.log("[ERROR] Failed to load interpreter source code");
          console.log(err);
        },
      });
    })
  });
}

// Create the query (parse the query).
function loadQuery(session) {
  var programText = document.getElementById("code").value;
  var tokens = tokenizer(programText);
  var formattedTokens = JSON.stringify(tokens).replaceAll('"', "");
  var completeQuery = `program(P, ${formattedTokens}, []), eval(P, [], EnvOut, ValueOut).`;
  console.log(completeQuery);
  session.query(completeQuery, {
    success: function (goal) {
      /* Goal parsed correctly */
      console.log("Successfully parsed query!");
      console.log(goal);
      findAnswer(session);
    },
    error: function (err) {
      console.log("[ERROR] Failed to parse query");
      console.log(err);
    },
  });
}

function findAnswer(session) {
  // Execute the query (execute the goal).
  session.answer({
    success: function (answer) {
      console.log(session.format_answer(answer));
      document.getElementById("output-label").innerHTML = OUTPUT_LABEL;
    },
    error: function (err) {
      /* Uncaught error */
      console.log("Error: " + err);
    },
    fail: function () {
      /* No more answers */
      console.log("No more answers!");
    },
    limit: function () {
      /* Limit exceeded */
      console.log("Limit exceeded!");
    },
  });
}

function writeOutput(message, overwrite = false) {
  if (overwrite) {
    document.getElementById("results").value = message;
  } else {
    document.getElementById("results").value += `${message}\n`;
  }
}

function tokenizer(fulltext) {
  var tokens = fulltext.split(/\s/).filter((token) => token.length > 0);
  return tokens;
}

function main() {
  populateCodeArea();
  hijackConsoleLog();
  prepareInterpreter();
  registerRunListener();
  registerExamplesListener();
}

main();
