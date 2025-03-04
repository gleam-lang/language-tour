import gleam/bool

pub fn main() {
  // Bool operators
  echo True && False
  echo True && True
  echo False || False
  echo False || True

  // Bool functions
  echo bool.to_string(True)
}
