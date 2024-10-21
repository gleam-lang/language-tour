pub fn main() {
  let ints = [1, 2, 3]

  echo ints

  // Immutably prepend
  echo [-1, 0, ..ints]

  // Uncomment this to see the error
  // echo ["zero", ..ints]

  // The original lists are unchanged
  echo ints
}
