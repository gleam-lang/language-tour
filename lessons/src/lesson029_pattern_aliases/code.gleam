import gleam/io

pub fn main() {
  io.debug(get_first_non_empty([[], [1, 2, 3], [4, 5]]))
  io.debug(get_first_non_empty([[1, 2], [3, 4, 5], []]))
  io.debug(get_first_non_empty([[], [], []]))
}

fn get_first_non_empty(lists: List(List(t))) -> List(t) {
  case lists {
    [[_, ..] as first, ..] -> first
    [_, ..rest] -> get_first_non_empty(rest)
    [] -> []
  }
}
