let INTERPRETER_CODE_PATH = "codeable.pl";
let LOADING_MSG = "Loading...";
let OUTPUT_LABEL = "Output";
let intermediateCode = "";

function populateCodeArea() {
  var sampleProgram = "show 25";
  var codeArea = document.getElementById("code");
  codeArea.value = sampleProgram;
}

function hijackConsoleLog() {
  let consoleLog = console.log;
  console.log = (message) => {
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
  var completeQuery = `program(P, ${formattedTokens}, []), write(P), program_eval(P, 2, 3, Z).`;
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
      writeOutput(session.format_answer(answer));
      console.log(answer); // {X/apple}
    },
    error: function (err) {
      /* Uncaught error */
      console.log("Error: " + err);
    },
    fail: function () {
      /* No more answers */
      document.getElementById("output-label").innerHTML = OUTPUT_LABEL;
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
