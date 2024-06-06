import gleam/io

pub fn main() {
  let add_one = fn(x) { x + 1 }
  let exclaim = fn(x) { x <> "!" }

  // Invalid, Int and String are not the same type
  // twice(10, exclaim)

  // Here the type variable is replaced by the type Int
  io.debug(twice(10, add_one))

  // Here the type variable is replaced by the type String
  io.debug(twice("Hello", exclaim))
}

// The name `value` refers to the same type multiple times
fn twice(argument: value, my_function: fn(value) -> value) -> value {
  my_function(my_function(argument))
}
