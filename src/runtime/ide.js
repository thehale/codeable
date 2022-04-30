/**
 * Authors: Joseph Hale, Jacob Janes, Rithvik Arun, 
Sai Nishanth Vaka, and Jacob Hreshchyshyn
 * Purpose: Interactivity for the browser based Codeable IDE
 * Date: 29 Apr 2022
 * Version: 0.1.0
 */

let INTERPRETER_CODE_PATH = "codeable.pl";
let LOADING_MSG = "Loading...";
let OUTPUT_LABEL = "Output";
let intermediateCode = "";

function populateCodeArea() {
  var sampleProgram = "greeting stores < hello world >\nshow greeting";
  var codeArea = document.getElementById("code");
  codeArea.value = sampleProgram;
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
}

main();
