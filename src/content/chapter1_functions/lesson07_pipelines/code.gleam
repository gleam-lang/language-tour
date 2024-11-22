import gleam/io
import gleam/string

pub fn main() {
  // Without the pipe operator
  io.debug(string.drop_start(string.drop_end("Hello, Joe!", 1), 7))

  // With the pipe operator
  "Hello, Mike!"
  |> string.drop_end(1)
  |> string.drop_start(7)
  |> io.debug

  // Changing order with function capturing
  "1"
  |> string.append("2")
  |> string.append("3", _)
  |> io.debug
}
