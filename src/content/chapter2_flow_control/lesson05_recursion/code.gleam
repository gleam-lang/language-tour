pub fn main() {
  echo factorial(5)
  echo factorial(7)
}

// A recursive functions that calculates factorial
pub fn factorial(x: Int) -> Int {
  case x {
    // Base case
    0 -> 1
    1 -> 1

    // Recursive case
    _ -> x * factorial(x - 1)
  }
}
