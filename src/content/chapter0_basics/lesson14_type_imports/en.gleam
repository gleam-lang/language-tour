import gleam/bytes_builder
import gleam/string_builder.{type StringBuilder}

pub fn main() {
  // Referring to a type in a qualified way
  let _bytes: bytes_builder.BytesBuilder = bytes_builder.new()

  // Refering to a type in an unqualified way
  let _text: StringBuilder = string_builder.new()
}
