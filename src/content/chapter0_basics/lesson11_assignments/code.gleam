import gleam/io

pub fn main() {
  let x = "Original"
  io.println(x)

  // Assign `y` to the value of `x`
  let y = x
  io.println(y)

  // Assign `x` to a new value
  let x = "New"
  io.println(x)

  // The `y` still refers to the original value
  io.println(y)
}
