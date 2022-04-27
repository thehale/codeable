function buildIntermediateCode(session) {
  // , write(P), program_eval(P, 2, 3, Z).
  session.query("listing.", {
    success: function(goal) { /* Goal parsed correctly */ 
      console.log("Successfully parsed query!");
      console.log(goal);
      loadQuery(session);
    },
    error: function(err) { /* Error parsing goal */ }
  });
}

// Create the query (parse the query).
function loadQuery(session) {
  // , write(P), program_eval(P, 2, 3, Z).
  session.query("program(P, [begin, const, z, =, 3, ;, end, .], []).", {
    success: function(goal) { /* Goal parsed correctly */ 
      console.log("Successfully parsed query!");
      console.log(goal);
      findAnswer(session);
    },
    error: function(err) { /* Error parsing goal */ }
  });
}

function findAnswer(session) {
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

function tokenizer(fulltext) {
    var tokens = fulltext.split(" ");
    return tokens;
}

function main() {
  console.log("Loading Custom JS Script!")
  var session = pl.create();

  // Create the session (parse the backing rules)
  session.consult("jhaleAssign3.pl", {
    success: function () { /* Program parsed correctly */ 
      console.log("Successfully loaded program!");
      buildIntermediateCode(session);
    },
    error: function (err) { /* Error parsing program */ }
  });

  var tokens = tokenizer('tower-of-hanoi disks with source with target with medium if disks is-greater-than 0 disks1 equals subtraction of disks with 1 tower-of-hanoi of disks1 with source with medium with target show-value-of " Move disk " with disks with " from rod " with source with " with rod " with target tower-of-hanoi of disks1 with medium with target with source move-on answer equals no-answer')
  console.log(tokens);
}

main();
