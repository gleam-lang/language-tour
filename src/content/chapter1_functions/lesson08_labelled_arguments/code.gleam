pub fn main() {
  // Without using labels
  echo calculate(1, 2, 3)

  // Using the labels
  echo calculate(1, add: 2, multiply: 3)

  // Using the labels in a different order
  echo calculate(1, multiply: 3, add: 2)
}

fn calculate(value: Int, add addend: Int, multiply multiplier: Int) {
  value * multiplier + addend
}
