pub fn main() {
  echo get_name("Hello, Joe")
  echo get_name("Hello, Mike")
  echo get_name("System still working?")
}

fn get_name(x: String) -> String {
  case x {
    "Hello, " <> name -> name
    _ -> "Unknown"
  }
}
