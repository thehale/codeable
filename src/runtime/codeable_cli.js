// Copyright (c) 2022 Rithvik Arun, Joseph Hale, Jacob Hreshchyshyn, Jacob Janes, Sai Nishanth Vaka
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
 * Purpose: CLI for executing Codeable
 * Date: 29 Apr 2022
 * Version: 0.1.0
 */

const fs = require('fs');
const pl = require('tau-prolog');
let INTERPRETER_CODE_PATH = "codeable.pl";

function tokenizeExecute(fileName){
  var data = ""
  fs.readFile(fileName, 'utf8', (err, data) => {
    if (err) {
      console.error(err);
      return;
    }
    // console.log(data);
    let session = pl.create();
    session.consult(INTERPRETER_CODE_PATH, {
      success: () => {
        console.log("[INFO] Loaded interpreter source code");
        loadQueryEx(session, data);
      },
      error: (err) => {
        console.log("[ERROR] Failed to load interpreter source code");
        console.log(err);
      },
    });
  });
}

function tokenizer(fulltext) {
  var tokens = fulltext.split(/\s/).filter((token) => token.length > 0);
  return tokens;
}

// Create the query (parse the query).
function loadQueryEx(session, programText) {
    var tokens = tokenizer(programText);
    var formattedTokens = JSON.stringify(tokens).replaceAll('"', "");
    var completeQuery = `program(P, ${formattedTokens}, []), eval(P, [], EnvOut, ValueOut).`;
    // console.log(completeQuery);
    session.query(completeQuery, {
      success: function (goal) {
        /* Goal parsed correctly */
        console.log("Successfully parsed query!");
        // console.log(goal);
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
        // console.log("==:ANSWER:==")
        //console.log(answer); // {X/apple}
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
  
  const myArgs = process.argv.slice(2);
  tokenizeExecute(myArgs[0]);
