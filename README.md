# The Gleam Language Tour

An interactive tour of the Gleam programming language.

```sh
# Download a wasm version of the Gleam compiler
rm -rf wasm-compiler
mkdir wasm-compiler
cd wasm-compiler
curl -L "https://github.com/gleam-lang/gleam/releases/download/v0.34.1/gleam-v0.34.1-browser.tar.gz" | tar xz
cd ..

# Build the site
gleam run

# It's now all the in `public/` directory
```
