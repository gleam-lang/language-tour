import gleam/io
import gleam/int

pub fn main() {
  io.debug(buy_pastry(10))
  io.debug(buy_pastry(8))
  io.debug(buy_pastry(5))
  io.debug(buy_pastry(3))
}

pub type PurchaseError {
  NotEnoughMoney(required: Int)
  NotLuckyEnough
}

fn buy_pastry(money: Int) -> Result(Int, PurchaseError) {
  case money >= 5 {
    True ->
      case int.random(4) == 0 {
        True -> Error(NotLuckyEnough)
        False -> Ok(money - 5)
      }
    False -> Error(NotEnoughMoney(required: 5))
  }
}
