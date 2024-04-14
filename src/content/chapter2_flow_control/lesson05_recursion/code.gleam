import gleam/io

pub fn main() {
  io.debug(factorial(5))
  io.debug(factorial(7))
}

// A recursive functions that calculates factorial
pub fn factorial(x: Int) -> Int {
  case x {
    // Base case
    0 | 1 -> 1

    // Recursive case
    _ -> x * factorial(x - 1)
  }
}
