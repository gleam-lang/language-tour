import gleam/io

pub type Fish {
  Starfish(name: String, favourite_color: String)
  Jellyfish(name: String, jiggly: Bool)
}

pub type IceCream {
  IceCream(flavour: String)
}

pub fn main() {
  let lucy = Starfish("Lucy", "Pink")
  let favourite_ice_cream = IceCream("strawberry")

  case lucy {
    Starfish(_, favourite_color) -> io.println(favourite_color)
    Jellyfish(name, ..) -> io.println(name)
  }

  // if the custom type has a single variant you can
  // destructure it using `let` instead of a case expression!
  let IceCream(flavour) = favourite_ice_cream
  io.println(flavour)
}
