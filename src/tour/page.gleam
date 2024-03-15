import gleam/list
import gleam/string
import gleam/string_builder
import htmb.{type Html, h, text}
import tour/document.{
  type HtmlAttribute, BodyConfig, HeadConfig, HtmlConfig, ScriptOptions,
}
import tour/widgets

pub type Link {
  Link(label: String, to: String)
}

/// Renders an HTML anchor tag
pub fn link(for link: Link, attributes attributes: List(HtmlAttribute)) -> Html {
  let link_attributes = [#("href", link.to), ..attributes]

  h("a", link_attributes, [text(link.label)])
}

/// Renders the tour's navbar as html
pub fn navbar(titled title: String, links links: List(Link)) -> Html {
  let links = list.map(links, fn(l) { link(l, [#("class", "link")]) })

  let nav_right_items = list.flatten([links, [widgets.theme_picker()]])

  h("nav", [#("class", "navbar")], [
    h("a", [#("href", "/"), #("class", "logo")], [
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

pub type ScriptConfig {
  ScriptConfig(head: List(Html), body: List(Html))
}

pub type PageConfig {
  PageConfig(
    path: String,
    title: String,
    content: List(Html),
    stylesheets: List(String),
    scripts: ScriptConfig,
  )
}

/// Renders a page in the language tour
pub fn html(page config: PageConfig) -> Html {
  // add path-specific class to body to make styling easier
  let body_class = #("id", "page" <> string.replace(config.path, "/", "-"))

  // render html
  document.html(HtmlConfig(
    head: HeadConfig(
      description: "An interactive introduction and reference to the Gleam programming language. Learn Gleam in your browser!",
      image: "https://gleam.run/images/og-image.png",
      title: config.title <> " - The Gleam Language Tour",
      url: "https://tour.gleam.run/" <> config.path,
      path: config.path,
      meta: [],
      stylesheets: ["/common.css", "/style.css", ..config.stylesheets],
      scripts: [
        document.script(
          "https://plausible.io/js/script.js",
          ScriptOptions(defer: True, module: False),
          [#("data-domain", "tour.gleam.run")],
        ),
        document.dangerous_inline_script(
          widgets.theme_picker_js,
          ScriptOptions(module: True, defer: False),
          [],
        ),
        ..config.scripts.head
      ],
    ),
    lang: "en-GB",
    attributes: [#("class", "theme-light")],
    body: BodyConfig(
      attributes: [body_class],
      scripts: config.scripts.body,
      static_content: [
        navbar(titled: "Gleam Language Tour", links: [
          Link(label: "gleam.run", to: "http://gleam.run"),
        ]),
      ],
      content: config.content,
    ),
  ))
}

pub fn render(page page_html: Html) -> String {
  page_html
  |> htmb.render_page("html")
  |> string_builder.to_string
}
