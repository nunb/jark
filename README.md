
# Project page

See [project page](http://icylisper.in/jark)

# SERVER
 
a. The server component can be included within your project

    Add :dependencies [[jark "0.4"]] to your project.clj file
or

b. Or use the jark CLI program

    $ jark vm start 

   and from the client

    $ jark vm connect [--host] [--port]

# CLIENT

## Building CLI client

    $ cabal install Shellac parsec Shellac-readline readline regex-compat pretty
    $ cd client/cli && make

This generates the jark cli-client.

# AUTHORS

Ambrose Bonnaire-Sergeant
Isaac Praveen


# LICENSE

Licensed under the EPL. (See the file epl.html.)
