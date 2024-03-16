import gleam/list
import htmb.{type Html, h, text}
import tour/document.{type HtmlAttribute}
import tour/widgets

pub type Link {
  Link(label: String, to: String)
}

/// Renders a styled text link
pub fn text_link(
  for link: Link,
  attributes attributes: List(HtmlAttribute),
) -> Html {
  let link_attributes = [#("class", "link"), ..attributes]

  document.anchor(link.to, link_attributes, [text(link.label)])
}

/// Renders the tour's navbar as html
pub fn navbar(titled title: String, links links: List(Link)) -> Html {
  let links = list.map(links, fn(l) { text_link(l, [#("class", "link")]) })

  let nav_right_items = list.flatten([links, [widgets.theme_picker()]])

  h("nav", [#("class", "navbar")], [
    document.anchor("/", [#("class", "logo")], [
      h(
        "img",
        [
          #("src", "https://gleam.run/images/lucy/lucy.svg"),
          #("alt", "Lucy the star, Gleam's mascot"),
        ],
        [],
      ),
      text(title),
    ]),
    h("div", [#("class", "nav-right")], nav_right_items),
  ])
}
