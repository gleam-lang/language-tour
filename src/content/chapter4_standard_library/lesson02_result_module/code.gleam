import gleam/int
import gleam/io
import gleam/result

pub fn main() {
  io.println("=== map ===")
  let _ = echo result.map(Ok(1), fn(x) { x * 2 })
  let _ = echo result.map(Error(1), fn(x) { x * 2 })

  io.println("=== try ===")
  let _ = echo result.try(Ok("1"), int.parse)
  let _ = echo result.try(Ok("no"), int.parse)
  let _ = echo result.try(Error(Nil), int.parse)

  io.println("=== unwrap ===")
  echo result.unwrap(Ok("1234"), "default")
  echo result.unwrap(Error(Nil), "default")

  io.println("=== pipeline ===")
  int.parse("-1234")
  |> result.map(int.absolute_value)
  |> result.try(int.remainder(_, 42))
  |> echo
}
