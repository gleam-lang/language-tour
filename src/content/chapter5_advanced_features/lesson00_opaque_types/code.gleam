import gleam/io

pub fn main() {
  let positive = new(1)
  let zero = new(0)
  let negative = new(-1)

  io.debug(to_int(positive))
  io.debug(to_int(zero))
  io.debug(to_int(negative))
}

pub opaque type PositiveInt {
  PositiveInt(inner: Int)
}

pub fn new(i: Int) -> PositiveInt {
  case i >= 0 {
    True -> PositiveInt(i)
    False -> PositiveInt(0)
  }
}

pub fn to_int(i: PositiveInt) -> Int {
  i.inner
}
