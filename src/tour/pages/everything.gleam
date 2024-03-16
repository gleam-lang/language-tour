//// tour.gleam.run/everyting
//// 
//// Displays a list of all chapters and their lessons
//// as well as a table of contents that allows for easy navigation

import gleam/list
import gleam/string
import gleam/string_builder
import htmb.{type Html, dangerous_unescaped_fragment, h, text}
import tour/types/lesson.{type Chapter, type Lesson}
import tour/components.{Link}
import tour/document
import tour/page.{PageConfig, ScriptConfig}
import tour/styles

const page_css = "/css/pages/everything.css"

fn slugify_path(path: String) -> String {
  string.replace(path, "/", "-")
  |> string.drop_left(up_to: 1)
}

fn separator(class: String) {
  h("hr", [#("class", class <> "-separator")], [])
}

fn lesson_html(lesson: Lesson, index: Int, end_index: Int) {
  let snippet_link_title = "Experiment with " <> lesson.name <> " in browser"

  let lesson_content =
    h("article", [#("class", "lesson"), #("id", slugify_path(lesson.path))], [
      h("a", [#("href", "#" <> slugify_path(lesson.path)), #("class", "link")], [
        h("h2", [#("class", "lesson-title")], [text(lesson.name)]),
      ]),
      dangerous_unescaped_fragment(string_builder.from_string(lesson.text)),
      h("pre", [#("class", "lesson-snippet hljs gleam language-gleam")], [
        h("code", [], [text(lesson.code)]),
        h(
          "a",
          [
            #("class", "lesson-snippet-link"),
            #("href", lesson.path),
            #("title", snippet_link_title),
            #("aria-label", snippet_link_title),
          ],
          [
            h("i", [#("class", "snippet-link-icon")], [text("</>")]),
            text("Run code snippet"),
          ],
        ),
      ]),
    ])

  case index {
    i if i == end_index -> [lesson_content]
    _ -> [lesson_content, separator("lesson")]
  }
}

fn chapters_html(chapters: List(Chapter)) -> List(Html) {
  use #(chapter, index) <- list.flat_map(
    list.index_map(chapters, fn(chap, i) { #(chap, i) }),
  )

  let lessons =
    list.index_map(chapter.lessons, fn(lesson, index) {
      lesson_html(lesson, index, list.length(chapter.lessons) - 1)
    })
  let chapter_title =
    h("h3", [#("id", slugify_path(chapter.path)), #("class", "chapter-title")], [
      text(chapter.name),
    ])

  let chapter_header = case index {
    0 -> [chapter_title, separator("chapter")]
    _ -> [separator("chapter-between"), chapter_title, separator("chapter")]
  }

  list.concat([chapter_header, ..lessons])
}

fn toc_link(lesson: Lesson) -> Html {
  h("li", [], [
    components.text_link(
      Link(label: lesson.name, to: "#" <> slugify_path(lesson.path)),
      [#("class", "link padded")],
    ),
  ])
}

fn toc_html(chapters: List(Chapter)) -> List(Html) {
  use chapter <- list.map(chapters)
  let links = list.map(chapter.lessons, toc_link)

  h("article", [#("class", "chapter"), #("id", "chapter-" <> chapter.name)], [
    h("h3", [], [text(chapter.name)]),
    h("ul", [], links),
  ])
}

/// Builds the /everything's page body content
fn html(chapters: List(Chapter)) -> Html {
  let chapter_lessons = chapters_html(chapters)
  let table_of_contents = toc_html(chapters)

  h("main", [#("id", "everything")], [
    h(
      "aside",
      [#("id", "everything-contents"), #("class", "dim-bg")],
      table_of_contents,
    ),
    h("section", [#("id", "everything-lessons")], chapter_lessons),
  ])
}

/// Renders the /everything page to a string
pub fn render(chapters: List(Chapter)) -> String {
  let content = html(chapters)

  // TODO: use proper values for location and such
  page.html(
    PageConfig(
      path: "everything",
      title: "Everything!",
      scripts: ScriptConfig(
        head: [
          document.script(
            "/js/highlight/highlight.core.min.js",
            document.ScriptOptions(module: True, defer: False),
            [],
          ),
          document.script(
            "/js/highlight/regexes.js",
            document.ScriptOptions(module: True, defer: True),
            [],
          ),
        ],
        body: [
          document.script(
            "/js/highlight/highlight-gleam.js",
            document.ScriptOptions(module: True, defer: True),
            [],
          ),
        ],
      ),
      stylesheets: [styles.page, page_css, ..styles.defaults_code],
      content: [content],
    ),
  )
  |> page.render
}
