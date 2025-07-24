// A type with no Gleam constructors
pub type DateTime

// An external function that creates an instance of the type
@external(javascript, "./my_package_ffi.mjs", "now")
pub fn now() -> DateTime

// The `now` function in `./my_package_ffi.mjs` looks like this:
// export function now() {
//   return new Date();
// }

pub fn main() {
  echo now()
}
