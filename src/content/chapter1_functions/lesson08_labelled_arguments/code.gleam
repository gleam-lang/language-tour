import gleam/io

pub fn main() {
  // Without using labels
  io.debug(calculate(1, 2, 3))

  // Using the labels
  io.debug(calculate(1, add: 2, multiply: 3))

  // Using the labels in a different order
  io.debug(calculate(1, multiply: 3, add: 2))

  // You may have some local variables declared
  let multiply = 3
  let add = 2

  // You can specify the variables by name when calling the function
  io.debug(calculate(1, add: add, multiply: multiply))

  // Or use shorthand syntax, if the variable names match the names of the
  // labelled arguments
  io.debug(calculate(1, add:, multiply:))
}

fn calculate(value: Int, add addend: Int, multiply multiplier: Int) {
  value * multiplier + addend
}
