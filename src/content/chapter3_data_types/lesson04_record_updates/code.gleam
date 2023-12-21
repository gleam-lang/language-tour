import gleam/io

pub type SchoolPerson {
  Teacher(name: String, subject: String, floor: Int, room: Int)
}

pub fn main() {
  let teacher1 = Teacher(name: "Mr Dodd", subject: "ICT", floor: 2, room: 2)

  // Use the update syntax
  let teacher2 = Teacher(..teacher1, subject: "PE", room: 6)

  io.debug(teacher1)
  io.debug(teacher2)
}
