import gleam/option.{type Option, None, Some}

pub type Person {
  Person(name: String, pet: Option(String))
}

pub fn main() {
  let person_with_pet = Person("Al", Some("Nubi"))
  let person_without_pet = Person("Maria", None)

  echo person_with_pet
  echo person_without_pet
}
