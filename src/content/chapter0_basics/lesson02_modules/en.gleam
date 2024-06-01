import gleam/io
import gleam/string as text

pub fn main() {
  // Use a function from the `gleam/io` module
  io.println("Hello, Mike!")

  // Use a function from the `gleam/string` module
  io.println(text.reverse("Hello, Joe!"))
}
