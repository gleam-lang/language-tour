pub fn main() {
  old_function()
  new_function()
}

@deprecated("Use new_function instead")
fn old_function() {
  Nil
}

fn new_function() {
  Nil
}
