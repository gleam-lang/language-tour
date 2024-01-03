import gleam/io
import gleam/int
import gleam/result

pub fn main() {
  io.println("=== map ===")
  io.debug(result.map(Ok(1), fn(x) { x * 2 }))
  io.debug(result.map(Error(1), fn(x) { x * 2 }))

  io.println("=== try ===")
  io.debug(result.try(Ok("1"), int.parse))
  io.debug(result.try(Ok("no"), int.parse))
  io.debug(result.try(Error(Nil), int.parse))

  io.println("=== unwrap ===")
  io.debug(result.unwrap(Ok("1234"), "default"))
  io.debug(result.unwrap(Error(Nil), "default"))

  io.println("=== pipeline ===")
  int.parse("-1234")
  |> result.map(int.absolute_value)
  |> result.try(int.remainder(_, 42))
  |> io.debug
}
