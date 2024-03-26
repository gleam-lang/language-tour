import gleam/io

pub type UserId =
  Int

pub fn main() {
  let one: UserId = 1
  let two: Int = 2

  // UserId and Int are the same type
  io.debug(one == two)
}
