import gleam/float

pub fn main() {
  // Float arithmetic
  echo 1.0 +. 1.5
  echo 5.0 -. 1.5
  echo 5.0 /. 2.5
  echo 3.0 *. 3.5

  // Float comparisons
  let one = 1.0
  echo 2.2 >. one
  echo 2.2 <. one
  echo 2.2 >=. one
  echo 2.2 <=. one

  // Equality works for any type
  echo 3.0 == 1.5 *. 2.0
  echo 2.1 == 1.2 +. 1.0

  // Division by zero is not an error
  echo 3.14 /. 0.0

  // Standard library float functions
  echo float.max(2.0, 9.5)
  echo float.ceiling(5.4)
}
