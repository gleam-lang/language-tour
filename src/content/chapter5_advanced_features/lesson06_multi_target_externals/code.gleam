import gleam/io

pub type DateTime

@external(erlang, "calendar", "local_time")
@external(javascript, "./my_package_ffi.mjs", "now")
pub fn now() -> DateTime

pub fn main() {
  io.debug(now())
}
