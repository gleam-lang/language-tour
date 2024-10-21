import gleam/io
import gleam/string

pub fn main() {
  // String literals
  io.println("👩‍💻 こんにちは Gleam 🏳️‍🌈")
  io.println(
    "multi
    line
    string",
  )
  io.println("\u{1F600}")

  // Double quote can be escaped
  io.println("\"X\" marks the spot")

  // String concatenation
  io.println("One " <> "Two")

  // String functions
  io.println(string.reverse("1 2 3 4 5"))
  io.println(string.append("abc", "def"))
}
