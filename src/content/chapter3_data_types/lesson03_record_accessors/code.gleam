pub type SchoolPerson {
  Teacher(name: String, subject: String)
  Student(name: String)
}

pub fn main() {
  let teacher = Teacher("Mr Schofield", "Physics")
  let student = Student("Koushiar")

  echo teacher.name
  echo student.name
  // echo student.subject
}
