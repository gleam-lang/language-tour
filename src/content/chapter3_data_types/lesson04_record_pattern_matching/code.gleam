import gleam/io

pub type Fish {
  Starfish(name: String, favourite_color: String)
  Jellyfish(name: String, jiggly: Bool)
}

pub fn main() {
  let lucy = Starfish("Lucy", "Pink")

  case lucy {
    Starfish(_, favourite_color) -> io.debug(favourite_color)
    Jellyfish(name, ..) -> io.debug(name)
  }
}
