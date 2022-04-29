const fs = require('fs');
const tokenizer = require('/ide')
const tau_prolog = require('/tau-prolog')

function readFileLoad(fileName, callback){
    
    return callback(data);
}

function tokenizeExecute(fileName){
    fs.readFile(fileName, 'utf8', (err, data) => {
        if (err) {
          console.error(err);
          return;
        }
        console.log(data);
    });
    let session = pl.create();
      session.consult(intermediateCode, {
        success: () => {
          console.log("[INFO] Loaded interpreter source code");
          loadQueryEx(session);
        },
        error: (err) => {
          console.log("[ERROR] Failed to load interpreter source code");
          console.log(err);
        },
    });
}

// Create the query (parse the query).
function loadQueryEx(session, programText) {
    var tokens = tokenizer.tokenizer(programText);
    var formattedTokens = JSON.stringify(tokens).replaceAll('"', "");
    var completeQuery = `program(P, ${formattedTokens}, []), write(P), eval(P, [], EnvOut, ValueOut).`;
    console.log(completeQuery);
    session.query(completeQuery, {
      success: function (goal) {
        /* Goal parsed correctly */
        console.log("Successfully parsed query!");
        console.log(goal);
        findAnswerEx(session);
      },
      error: function (err) {
        console.log("[ERROR] Failed to parse query");
        console.log(err);
      },
    });
  }
  
  function findAnswerEx(session) {
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
        console.log("No more answers!");
      },
      limit: function () {
        /* Limit exceeded */
        console.log("Limit exceeded!");
      },
    });
  }
  