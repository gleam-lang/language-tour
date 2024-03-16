import gleam/option.{type Option}

pub type Chapter {
  Chapter(name: String, path: String, lessons: List(Lesson))
}

pub type Lesson {
  Lesson(
    name: String,
    text: String,
    code: String,
    path: String,
    previous: Option(String),
    next: Option(String),
  )
}
