pub type Person {
  Person(name: String, age: Int, needs_glasses: Bool)
}

pub fn main() {
  let amy = Person("Amy", 26, True)
  let jared = Person(name: "Jared", age: 31, needs_glasses: True)
  let tom = Person("Tom", 28, needs_glasses: False)

  let friends = [amy, jared, tom]
  echo friends
}
