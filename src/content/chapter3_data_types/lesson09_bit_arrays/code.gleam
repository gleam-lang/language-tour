pub fn main() {
  // 8 bit int. In binary: 00000011
  echo <<3>>
  echo <<3>> == <<3:size(8)>>

  // 16 bit int. In binary: 0001100000000011
  echo <<6147:size(16)>>

  // A bit array of UTF8 data
  echo <<"Hello, Joe!":utf8>>

  // Concatenation
  let first = <<4>>
  let second = <<2>>
  echo <<first:bits, second:bits>>
}
