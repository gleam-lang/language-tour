import gleam/io
import gleam/result

pub fn main() {
  let x = {
    use username <- result.try(get_usename())
    use password <- result.try(get_password())
    use greeting <- result.map(log_in(username, password))
    greeting <> ", " <> username
  }

  case x {
    Ok(greeting) -> io.println(greeting)
    Error(error) -> io.println_error(error)
  }
}

// Here are some pretend functions for this example:

fn get_usename() {
  Ok("alice")
}

fn get_password() {
  Ok("hunter2")
}

fn log_in(_username: String, _password: String) {
  Ok("Welcome")
}
