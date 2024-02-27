import gleam/io

// Notice that the `type` keyword is used when importing types such
// as `Option` but not when importing values like `None` or `Some`.
import gleam/option.{type Option, None, Some}

pub type Person {
  Person(name: String, pet: Option(String))
}

pub fn main() {
  let person_with_pet = Person("Al", Some("Nubi"))
  let person_without_pet = Person("Maria", None)

  io.debug(person_with_pet)
  io.debug(person_without_pet)
}
