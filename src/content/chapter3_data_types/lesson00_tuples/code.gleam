import gleam/io

pub fn main() {
  let triple = #(1, 2.2, "three")
  io.debug(triple)

  let #(a, _, _) = triple
  io.debug(a)
  io.debug(triple.1)
}
