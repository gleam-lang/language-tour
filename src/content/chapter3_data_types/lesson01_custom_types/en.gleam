import gleam/io

pub type Season {
  Spring
  Summer
  Autumn
  Winter
}

pub fn main() {
  io.debug(weather(Spring))
  io.debug(weather(Autumn))
}

fn weather(season: Season) -> String {
  case season {
    Spring -> "Mild"
    Summer -> "Hot"
    Autumn -> "Windy"
    Winter -> "Cold"
  }
}
