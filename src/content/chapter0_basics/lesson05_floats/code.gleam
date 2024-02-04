import gleam/io
import gleam/float

pub fn main() {
  // Float arithmetic
  io.debug(1.0 +. 1.5)
  io.debug(5.0 -. 1.5)
  io.debug(5.0 /. 2.5)
  io.debug(3.0 *. 3.5)

  // Float comparisons
  io.debug(2.2 >. 1.3)
  io.debug(2.2 <. 1.3)
  io.debug(2.2 >=. 1.3)
  io.debug(2.2 <=. 1.3)

  // Equality works for any type
  io.debug(1.1 == 1.1)
  io.debug(2.1 == 1.2)

  // Division by zero is not an error
  io.debug(3.14 /. 0.0)

  // Standard library float functions
  io.debug(float.max(2.0, 9.5))
  io.debug(float.ceiling(5.4))
}
