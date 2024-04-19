import gleam/dict
import gleam/io

pub fn main() {
  let scores = dict.from_list([#("Lucy", 13), #("Drew", 15)])
  io.debug(scores)

  let scores =
    scores
    |> dict.insert("Bushra", 16)
    |> dict.insert("Darius", 14)
    |> dict.delete("Drew")
  io.debug(scores)
}
