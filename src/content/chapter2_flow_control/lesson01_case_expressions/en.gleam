import gleam/int
import gleam/io

pub fn main() {
  let x = int.random(5)
  io.debug(x)

  let result = case x {
    // Match specific values
    0 -> "Zero"
    1 -> "One"

    // Match any other value
    _ -> "Other"
  }
  io.debug(result)
}
