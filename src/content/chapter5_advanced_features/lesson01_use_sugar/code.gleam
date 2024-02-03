import gleam/io
import gleam/result

pub fn main() {
  let x = {
    use username <- result.try(get_username())
    use password <- result.try(get_password())
    use greeting <- result.map(log_in(username, password))
    greeting <> ", " <> username
  }

  case x {
    Ok(greeting) -> io.println(greeting)
    Error(error) -> io.println("ERROR:" <> error)
  }
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
