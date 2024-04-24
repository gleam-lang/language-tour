import gleam/io

pub type Fish {
  Starfish(name: String, favourite_color: String)
  // Jellyfish(name: String, jiggly: Bool)
  // Swordfish(name: String)
}

pub fn main() {
  let lucy = Starfish("Lucy", "Pink")
  let cassie = Starfish("Cassie", "Orange")
  // let james = Jellyfish("James", True)
  // let sammy = Swordfish("Sammy")

  let Starfish(lucy_name, lucy_colour) = lucy
  let Starfish(cassie_name, ..) = cassie
  // let Jellyfish(_, is_jiggly) = james
  // let Swordfish(sammy_name) = sammy

  let names = [lucy_name, cassie_name]

  io.debug(names)
  io.debug(lucy_colour)
  // io.debug(is_jiggly)
}
