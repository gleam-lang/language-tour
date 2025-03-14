import gleam/int
import gleam/list

pub fn main() {
  let x = list.repeat(int.random(5), times: int.random(3))
  echo x

  let result = case x {
    [] -> "Empty list"
    [1] -> "List of just 1"
    [4, ..] -> "List starting with 4"
    [_, _] -> "List of 2 elements"
    _ -> "Some other list"
  }
  echo result
}
