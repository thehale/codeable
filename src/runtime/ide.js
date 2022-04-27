var tokenizer = require("./tokenizer");

console.log("Loading Custom JS Script!")
var session = pl.create();

// Create the session (parse the backing rules)
session.consult("fruit.pl", {
  success: function () { /* Program parsed correctly */ 
    console.log("Successfully loaded program!");
    loadQuery();
  },
  error: function (err) { /* Error parsing program */ }
});

// Create the query (parse the query).
function loadQuery() {
  session.query("fruits_in([carrot, apple, banana, broccoli], X).", {
    success: function(goal) { /* Goal parsed correctly */ 
      console.log("Successfully parsed query!");
      console.log(goal);
      findAnswer();
    },
    error: function(err) { /* Error parsing goal */ }
  });
}

function findAnswer() {
  // Execute the query (execute the goal).
  session.answer({
    success: function(answer) {
        console.log(session.format_answer(answer)); // {X/apple}

        // Ask for another answer after getting the first one.
        //session.answer({
        //    success: function(answer) {
        //        console.log(answer); // {X/banana}
        //   },
            // error, fail, limit
        //});
    },
    error: function(err) { /* Uncaught error */ 
      console.log("Error: " + err);
    },
    fail:  function() { /* No more answers */ 
      console.log("No more answers!");
    },
    limit: function() { /* Limit exceeded */ 
      console.log("Limit exceeded!");
    }
  });
}