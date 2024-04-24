import gleam/io

pub fn main() {
  let x = Nil
  io.debug(x)

  // let y: List(String) = Nil

  let result = io.println("Hello!")
  io.debug(result == Nil)
}
