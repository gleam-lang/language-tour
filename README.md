# The Gleam Language Tour

An interactive tour of the Gleam programming language.

## Setup

In order to run this project you will need the following prerequisites: 

 - Node.js (https://nodejs.org/en/download)
   - http-server (https://www.npmjs.com/package/http-server)
 - Gleam (https://gleam.run/getting-started/installing/)
 - Gleam's wasm compiler (use `./bin/download-compiler`)

_Node: Codespace users will have this installed automatically_

## Running the site

```sh
# Running the project will generate a static site under the `public/` folder
gleam run

# Running the server will serve the newly created static files
http-server public/
```