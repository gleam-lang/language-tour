import gleam/io
import gleam/string

pub fn main() {
  // String literals
  io.debug("👩‍💻 こんにちは Gleam 🏳️‍🌈")
  io.debug(
    "multi
    line
    string",
  )
  io.debug("\u{1F600}")

  // Use io.println to see an escape sequence in action
  io.println("\"X\" marks the spot")

  // String concatenation
  io.debug("One " <> "Two")

  // String functions
  io.debug(string.reverse("1 2 3 4 5"))
  io.debug(string.append("abc", "def"))
}
