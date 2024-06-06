import gleam/io

@external(erlang, "lists", "reverse")
pub fn reverse_list(items: List(e)) -> List(e) {
  tail_recursive_reverse(items, [])
}

fn tail_recursive_reverse(items: List(e), reversed: List(e)) -> List(e) {
  case items {
    [] -> reversed
    [first, ..rest] -> tail_recursive_reverse(rest, [first, ..reversed])
  }
}

pub fn main() {
  io.debug(reverse_list([1, 2, 3, 4, 5]))
  io.debug(reverse_list(["a", "b", "c", "d", "e"]))
}
