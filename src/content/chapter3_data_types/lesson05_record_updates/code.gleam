pub type SchoolPerson {
  Teacher(name: String, subject: String, floor: Int, room: Int)
}

pub type ClassRoom {
  ClassRoom(Int, subject: String, floor: Int)
}

pub fn main() {
  let teacher1 = Teacher(name: "Mr Dodd", subject: "ICT", floor: 2, room: 2)

  // Use the update syntax
  let teacher2 = Teacher(..teacher1, subject: "PE", room: 6)

  echo teacher1
  echo teacher2

  // Will not copy positional field
  let room1 = ClassRoom(1, subject: "Algebra", floor: 3)
  let room2 = ClassRoom(..room1, subject: "Geometry")
  echo room2
  // ClassRoom("Geometry", subject: 3, floor: Nil)
}
