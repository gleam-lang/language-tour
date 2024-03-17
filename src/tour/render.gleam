import htmb.{type Html, h, text}
import gleam/list
import gleam/string
import gleam/string_builder

pub type HtmlAttribute =
  #(String, String)

pub type ScriptOptions {
  ScriptOptions(module: Bool, defer: Bool)
}

/// Formats js script options into usage html attributes
fn script_common_attributes(attributes: ScriptOptions) -> List(HtmlAttribute) {
  let type_attr = #("type", case attributes.module {
    True -> "module"
    _ -> "text/javascript"
  })
  let defer_attr = #("defer", "")

  case attributes.defer {
    True -> [defer_attr, type_attr]
    _ -> [type_attr]
  }
}

/// Renders an HTML script tag
pub fn script(
  src source: String,
  options attributes: ScriptOptions,
  attributes additional_attributes: List(HtmlAttribute),
) -> Html {
  let attrs = {
    let src_attr = #("src", source)
    let base_attrs = [src_attr, ..script_common_attributes(attributes)]
    list.flatten([base_attrs, additional_attributes])
  }
  h("script", attrs, [])
}

/// Renders an inline HTML script tag
pub fn dangerous_inline_script(
  script content: String,
  options attributes: ScriptOptions,
  attributes additional_attributes: List(HtmlAttribute),
) -> Html {
  let attrs = {
    list.flatten([script_common_attributes(attributes), additional_attributes])
  }
  h("script", attrs, [
    htmb.dangerous_unescaped_fragment(string_builder.from_string(content)),
  ])
}

/// Renders an HTML meta tag
pub fn meta(data attributes: List(HtmlAttribute)) -> Html {
  h("meta", attributes, [])
}

/// Renders an HTML meta property tag
pub fn meta_prop(property: String, content: String) -> Html {
  meta([#("property", property), #("content", content)])
}

/// Renders an HTML link tag
pub fn link(rel: String, href: String) -> Html {
  h("link", [#("rel", rel), #("href", href)], [])
}

/// Renders a stylesheet link tag
pub fn stylesheet(src: String) -> Html {
  link("stylesheet", src)
}

/// Renders an HTML title tag
pub fn title(title: String) -> Html {
  h("title", [], [text(title)])
}

pub type HeadConfig {
  HeadConfig(
    path: String,
    title: String,
    description: String,
    url: String,
    image: String,
    meta: List(Html),
    stylesheets: List(String),
    scripts: List(Html),
  )
}

/// Renders the page head as HTML
fn head(with config: HeadConfig) -> htmb.Html {
  let meta_tags = [
    meta_prop("og:type", "website"),
    meta_prop("og:title", config.title),
    meta_prop("og:description", config.description),
    meta_prop("og:url", config.url),
    meta_prop("og:image", config.image),
    meta_prop("twitter:card", "summary_large_image"),
    meta_prop("twitter:url", config.url),
    meta_prop("twitter:title", config.title),
    meta_prop("twitter:description", config.description),
    meta_prop("twitter:image", config.image),
    ..config.meta
  ]

  let head_meta = [
    meta([#("charset", "utf-8")]),
    meta([
      #("name", "viewport"),
      #("content", "width=device-width, initial-scale=1"),
    ]),
    title(config.title),
    meta([#("name", "description"), #("content", config.description)]),
    ..meta_tags
  ]

  let head_links = [
    link("shortcut icon", "https://gleam.run/images/lucy/lucy.svg"),
    ..list.map(config.stylesheets, stylesheet)
  ]

  let head_content = list.concat([head_meta, head_links, config.scripts])

  h("head", [], head_content)
}

pub type BodyConfig {
  BodyConfig(
    content: List(Html),
    static_content: List(Html),
    scripts: List(Html),
    attributes: List(HtmlAttribute),
  )
}

/// Renders an Html body tag
fn body(with config: BodyConfig) -> Html {
  let content =
    list.flatten([config.static_content, config.content, config.scripts])

  h("body", config.attributes, content)
}

pub type HtmlConfig {
  HtmlConfig(
    attributes: List(HtmlAttribute),
    lang: String,
    head: HeadConfig,
    body: BodyConfig,
  )
}

/// Renders an HTML tag and its children
fn html(with config: HtmlConfig) -> Html {
  let attributes = [#("lang", config.lang), ..config.attributes]

  h("html", attributes, [head(config.head), body(config.body)])
}

pub type ScriptConfig {
  ScriptConfig(head: List(Html), body: List(Html))
}

pub type PageConfig {
  PageConfig(
    path: String,
    title: String,
    content: List(Html),
    static_content: List(Html),
    stylesheets: List(String),
    scripts: ScriptConfig,
  )
}

/// Renders a page in the language tour
pub fn render_html(page config: PageConfig) -> Html {
  // add path-specific class to body to make styling easier
  let body_class = #("id", "page" <> string.replace(config.path, "/", "-"))

  // render html
  html(HtmlConfig(
    head: HeadConfig(
      description: "An interactive introduction and reference to the Gleam programming language. Learn Gleam in your browser!",
      image: "https://gleam.run/images/og-image.png",
      title: config.title <> " - The Gleam Language Tour",
      url: "https://tour.gleam.run/" <> config.path,
      path: config.path,
      meta: [],
      stylesheets: config.stylesheets,
      scripts: [
        script(
          "https://plausible.io/js/script.js",
          ScriptOptions(defer: True, module: False),
          [#("data-domain", "tour.gleam.run")],
        ),
        ..config.scripts.head
      ],
    ),
    lang: "en-GB",
    attributes: [#("class", "theme-light theme-init")],
    body: BodyConfig(
      attributes: [body_class],
      scripts: config.scripts.body,
      static_content: config.static_content,
      content: config.content,
    ),
  ))
}

pub fn render_string(page page_html: Html) -> String {
  page_html
  |> htmb.render_page("html")
  |> string_builder.to_string
}

pub fn render(page config: PageConfig) -> String {
  config
  |> render_html
  |> render_string
}
