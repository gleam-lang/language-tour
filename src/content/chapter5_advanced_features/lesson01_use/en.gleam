import gleam/io
import gleam/result

pub fn main() {
  let _ = io.debug(without_use())
  let _ = io.debug(with_use())
}

pub fn without_use() {
  result.try(get_username(), fn(username) {
    result.try(get_password(), fn(password) {
      result.map(log_in(username, password), fn(greeting) {
        greeting <> ", " <> username
      })
    })
  })
}

pub fn with_use() {
  use username <- result.try(get_username())
  use password <- result.try(get_password())
  use greeting <- result.map(log_in(username, password))
  greeting <> ", " <> username
}

// Here are some pretend functions for this example:

fn get_username() {
  Ok("alice")
}

fn get_password() {
  Ok("hunter2")
}

fn log_in(_username: String, _password: String) {
  Ok("Welcome")
}
