let INTERPRETER_CODE_PATH = "jhaleAssign3.pl";
let intermediateCode = "";

function hijackConsoleLog() {
  let consoleLog = console.log;
  console.log = (message) => {
    if (message.toString().indexOf("codeable_version") > 0) {
      consoleLog("[DEBUG] Capturing intermediate code");
      intermediateCode = message;
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
        .replace("[)|", "[')'|");
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

function registerRunListener() {
  let runButton = document.getElementById("run");
  runButton.addEventListener("click", (el, ev) => {
    let session = pl.create()
    session.consult(intermediateCode, {
      success: () => {
        console.log("[INFO] Loaded interpreter source code");
        loadQuery(session);
      },
      error: (err) => {
        console.log("[ERROR] Failed to load interpreter source code");
        console.log(err)
      },
    })
  });
}

// Create the query (parse the query).
function loadQuery(session) {
  // , write(P), program_eval(P, 2, 3, Z).
  session.query("program(P, [begin, var, z, ; , var, x, ;, z, :=, x, end, .], []), write(P), program_eval(P, 2, 3, Z).", {
    success: function (goal) {
      /* Goal parsed correctly */
      console.log("Successfully parsed query!");
      console.log(goal);
      findAnswer(session);
    },
    error: function (err) {
      /* Error parsing goal */
    },
  });
}

function findAnswer(session) {
  // Execute the query (execute the goal).
  session.answer({
    success: function (answer) {
      console.log(session.format_answer(answer)); // {X/apple}
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

function tokenizer(fulltext) {
  var tokens = fulltext.split(" ");
  return tokens;
}

function main() {
  hijackConsoleLog();
  prepareInterpreter();
  registerRunListener();

  var tokens = tokenizer(
    'tower-of-hanoi disks with source with target with medium if disks is-greater-than 0 disks1 equals subtraction of disks with 1 tower-of-hanoi of disks1 with source with medium with target show-value-of " Move disk " with disks with " from rod " with source with " with rod " with target tower-of-hanoi of disks1 with medium with target with source move-on answer equals no-answer'
  );
  console.log(tokens);
}

main();