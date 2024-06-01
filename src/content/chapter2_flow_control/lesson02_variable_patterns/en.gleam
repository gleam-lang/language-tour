import gleam/int
import gleam/io

pub fn main() {
  let result = case int.random(5) {
    // Match specific values
    0 -> "Zero"
    1 -> "One"

    // Match any other value and assign it to a variable
    other -> "It is " <> int.to_string(other)
  }
  io.debug(result)
}
