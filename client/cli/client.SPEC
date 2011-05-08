
* client should have minimum runtime dependencies
* client should run on all OS platforms
* client should be extremely thin as possible

  Comment:
        Therefore we opted for Haskell which generates fast native small binaries.

* The client does the following 4 things
   * Provides a rich and thin clojure REPL
   * Sends expressions from the REPL to remote VM and intercepts output appropriately
   * Dispatches NFA(namespace function args) to the dispatcher(on the server) for command-line execution
   * Starts up the VM and provides an interface to monitor and manage it.
