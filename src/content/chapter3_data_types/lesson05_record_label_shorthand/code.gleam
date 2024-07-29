import gleam/io

pub type Trainer {
  Trainer(name: String, badges: Int)
}

fn new_trainer(name: String) -> Trainer {
  Trainer(name:, badges: 0)
}

fn greet(trainer: Trainer) -> String {
  case trainer {
    Trainer(badges: 8, ..) -> "Wow, you've got all the badges!"
    Trainer(name:, ..) -> "Hello " <> name <> "!"
  }
}

pub fn main() {
  let trainer = new_trainer("Sarah")
  io.println(greet(trainer))
}
