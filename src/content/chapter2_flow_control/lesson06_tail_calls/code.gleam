pub fn main() {
  echo factorial(5)
  echo factorial(7)
}

pub fn factorial(x: Int) -> Int {
  // The public function calls the private tail recursive function
  factorial_loop(x, 1)
}

fn factorial_loop(x: Int, accumulator: Int) -> Int {
  case x {
    0 -> accumulator
    1 -> accumulator

    // The last thing this function does is call itself
    // In the previous lesson the last thing it did was multiply two ints
    _ -> factorial_loop(x - 1, accumulator * x)
  }
}
