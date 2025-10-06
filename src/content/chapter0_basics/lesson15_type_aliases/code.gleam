pub type UserId =
  Int

pub fn main() {
  let one: UserId = 1
  let two: Int = 2

  // UserId and Int can be compared,
  // because they are of the same type,
  // but they are of different value.
  echo one == two
}
