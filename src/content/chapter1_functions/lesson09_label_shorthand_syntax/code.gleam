pub fn main() {
  let quantity = 5.0
  let unit_price = 10.0
  let discount = 0.2

  // Explicitly providing local variable names when calling the function.
  calculate_total_cost(
    quantity: quantity,
    unit_price: unit_price,
    discount: discount,
  )

  // However, since our local variable names are identical to the argument
  // labels, we can omit the variable names entirely and use shorthand label
  // syntax.
  calculate_total_cost(quantity:, unit_price:, discount:)
}

fn calculate_total_cost(
  quantity quantity: Float,
  unit_price price: Float,
  discount discount: Float,
) -> Float {
  let subtotal = quantity *. price
  let discount = subtotal *. discount

  subtotal -. discount
}
