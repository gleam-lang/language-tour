import gleam/io

const ints: List(Int) = [1, 2, 3]

const floats = [1.1, 2.2, 3.3]

pub fn main() {
  io.debug(ints)
  io.debug(ints == [1, 2, 3])

  io.debug(floats)
  io.debug(floats == [1.1, 2.2, 3.3])
}
