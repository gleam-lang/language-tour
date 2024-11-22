import gleam/bytes_tree
import gleam/string_tree.{type StringTree}

pub fn main() {
  // Referring to a type in a qualified way
  let _bytes: bytes_tree.BytesTree = bytes_tree.new()

  // Refering to a type in an unqualified way
  let _text: StringTree = string_tree.new()
}
