pub fn main() {
  assert add(1, 2) == 3

  assert add(1, 2) < add(1, 3)

  assert add(6, 2) == add(2, 6) as "Addition should be commutative"

  assert add(2, 2) == 5
}

fn add(a: Int, b: Int) -> Int {
  a + b
}
