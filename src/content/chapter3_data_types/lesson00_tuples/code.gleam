pub fn main() {
  let triple = #(1, 2.2, "three")
  echo triple

  let #(a, _, _) = triple
  echo a
  echo triple.1
}
