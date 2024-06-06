import gleam/io
import gleam/list

pub fn main() {
  let ints = [0, 1, 2, 3, 4, 5]

  io.println("=== map ===")
  io.debug(list.map(ints, fn(x) { x * 2 }))

  io.println("=== filter ===")
  io.debug(list.filter(ints, fn(x) { x % 2 == 0 }))

  io.println("=== fold ===")
  io.debug(list.fold(ints, 0, fn(count, e) { count + e }))

  io.println("=== find ===")
  let _ = io.debug(list.find(ints, fn(x) { x > 3 }))
  io.debug(list.find(ints, fn(x) { x > 13 }))
}
