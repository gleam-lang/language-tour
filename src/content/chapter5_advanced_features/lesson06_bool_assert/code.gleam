import gleam/result

pub fn ok_error_test() {
  assert result.is_ok(Ok("Hello"))
  assert !result.is_ok(Error("Bad request"))

  assert result.is_error(Error(Nil))
  assert !result.is_error(Ok(42))
}
