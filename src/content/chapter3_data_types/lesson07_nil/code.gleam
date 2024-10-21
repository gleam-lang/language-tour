import gleam/io

pub fn main() {
  let x = Nil
  echo x

  // let y: List(String) = Nil

  let result = io.println("Hello!")
  echo { result == Nil }
}
