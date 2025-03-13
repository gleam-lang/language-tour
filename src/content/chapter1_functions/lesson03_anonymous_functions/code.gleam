pub fn main() {
  // Assign an anonymous function to a variable
  let add_one = fn(a) { a + 1 }
  echo twice(1, add_one)

  // Pass an anonymous function as an argument
  echo twice(1, fn(a) { a * 2 })

  let secret_number = 42
  // This anonymous function always returns 42
  let secret = fn() { secret_number }
  echo secret()
}

fn twice(argument: Int, my_function: fn(Int) -> Int) -> Int {
  my_function(my_function(argument))
}
