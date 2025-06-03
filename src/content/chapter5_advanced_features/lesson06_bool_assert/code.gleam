import gleam/result

pub fn main() {
  assert result.is_ok(Ok("Hello"))
  assert !result.is_ok(Error("Bad request"))

  assert result.is_error(Error(Nil))
  assert !result.is_error(Ok(42))
}
