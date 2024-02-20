import gleam/io

pub fn main() {
  let a = unsafely_get_first_element([123])
  io.debug(a)

  let b = unsafely_get_first_element([])
  io.debug(b)
}

pub fn unsafely_get_first_element(items: List(a)) -> a {
  // This will panic if the list is empty.
  // A regular `let` would not permit this partial pattern
  let assert [first, ..] = items
  first
}
