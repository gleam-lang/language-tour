import gleam/int

pub fn main() {
  // Int arithmetic
  echo 1 + 1
  echo 5 - 1
  echo 5 / 2
  echo 3 * 3
  echo 5 % 2

  // Int comparisons
  echo 2 > 1
  echo 2 < 1
  echo 2 >= 1
  echo 2 <= 1

  // Equality works for any type
  echo 1 == 1
  echo 2 == 1

  // Standard library int functions
  echo int.max(42, 77)
  echo int.clamp(5, 10, 20)
}
