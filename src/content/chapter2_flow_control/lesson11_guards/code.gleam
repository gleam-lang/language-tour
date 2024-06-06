import gleam/io

pub fn main() {
  let numbers = [1, 2, 3, 4, 5]
  io.debug(get_first_larger(numbers, 3))
  io.debug(get_first_larger(numbers, 5))
}

fn get_first_larger(numbers: List(Int), limit: Int) -> Int {
  case numbers {
    [first, ..] if first > limit -> first
    [_, ..rest] -> get_first_larger(rest, limit)
    [] -> 0
  }
}
