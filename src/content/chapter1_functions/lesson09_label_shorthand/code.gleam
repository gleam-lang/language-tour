import gleam/io

pub fn main() {
  let title = "Chapter 1"
  let content =
    "Brownie caramels pastry danish candy lollipop soufflé dragée bonbon."

  // Using labels
  print(title: title, content: content)

  // Using the labels shorthand
  print(title:, content:)
}

fn print(title title: String, content content: String) -> Nil {
  io.println("# " <> title)
  io.println("")
  io.println(content)
}
