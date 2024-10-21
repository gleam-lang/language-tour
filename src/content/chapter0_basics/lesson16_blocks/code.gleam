pub fn main() {
  let fahrenheit = {
    let degrees = 64
    degrees
  }
  // echo degrees // <- This will not compile

  // Changing order of evaluation
  let celsius = { fahrenheit - 32 } * 5 / 9
  echo celsius
}
