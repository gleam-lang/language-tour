import gleam/io

pub fn main() {
  // 8 bit int. In binary: 00000011
  io.debug(<<3>>)
  io.debug(<<3>> == <<3:size(8)>>)

  // 16 bit int. In binary: 0001100000000011
  io.debug(<<6147:size(16)>>)

  // A bit array of UTF8 data
  io.debug(<<"Hello, Joe!":utf8>>)

  // Concatenation
  let first = <<4>>
  let second = <<2>>
  io.debug(<<first:bits, second:bits>>)
}
