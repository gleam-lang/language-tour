import filepath
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import gleam/string_builder
import htmb.{type Html, h, text}
import simplifile
import snag
import tour/render.{PageConfig, ScriptConfig}
import tour/widgets.{Link}

const static = "static"

const public = "public"

const public_precompiled = "public/precompiled"

const prelude = "build/dev/javascript/prelude.mjs"

const stdlib_compiled = "build/dev/javascript/gleam_stdlib/gleam"

const stdlib_sources = "build/packages/gleam_stdlib/src/gleam"

const stdlib_external = "build/packages/gleam_stdlib/src"

const compiler_wasm = "./wasm-compiler"

const content_path = "src/content"

const hello_joe = "import gleam/io

pub fn main() {
  io.println(\"Hello, Joe!\")
}
"

const hello_mike = "import gleam/io
import gleam/list

pub fn main() {
  list.each(erlang_the_movie, io.println)
}

const erlang_the_movie = [
  \"📞\", \"Hello, Mike!\", \"Hello, Joe!\", \"System working?\", \"Seems to be.\",
  \"OK, fine.\", \"OK.\", \"💫\",
]
"

const home_html = "
<p>
  This tour covers all aspects of the Gleam language, and assuming you have some
  prior programming experience should teach you everything you need to write
  real programs in Gleam.
</p>
<p>
  The tour is interactive! The code shown is editable and will be compiled and
  evaluated as you type. Anything you print using <code>io.println</code> or
  <code>io.debug</code> will be shown in the bottom section, along with any
  compile errors and warnings. To evaluate Gleam code the tour compiles Gleam to
  JavaScript and runs it, all entirely within your browser window.
</p>
<p>
  If at any point you get stuck or have a question do not hesitate to ask in
  <a href=\"https://discord.gg/Fm8Pwmy\">the Gleam Discord server</a>. We're here
  to help, and if you find something confusing then it's likely others will too,
  and we want to know about it so we can improve the tour.
</p>
<p>
  OK, let's go. Click \"Next\" to get started, or click \"Contents\" to jump to a
  specific topic.
</p>
"

const what_next_html = "
<p>
  Congratulations on completing the tour! Here's some ideas for what to do next:
</p>

<p>
  Read the <a href=\"https://gleam.run/writing-gleam\">Writing Gleam
  guide</a> to learn how to create and develop a Gleam project.
</p>
<p>
  Join the <a href=\"https://discord.gg/Fm8Pwmy\">the Gleam Discord server</a>
  and meet the community. They're friendly and helpful!
</p>
<p>
  Enroll in the <a href=\"https://exercism.io/tracks/gleam\">Exercism
  Gleam track</a> to practice your Gleam skills through a series of exercises
  and optionally get feedback from experienced Gleam developers.
</p>
<p>
  Happy hacking!
</p>
"

// page paths

const path_home = "/"

const path_table_of_contents = "/table-of-contents"

const path_what_next = "/what-next"

const path_everything = "/everything"

// Don't include deprecated stdlib modules
const skipped_stdlib_modules = [
  "bit_string.gleam", "bit_builder.gleam", "map.gleam",
]

// css stylesheets paths

const css__gleam_common = "/common.css"

/// Loads fonts and defines font sizes
const css_fonts = "/css/fonts.css"

/// Derives app colors for both dark & light themes from common.css variables
const css_theme = "/css/theme.css"

/// Defines layout unit variables
const css_layout = "/css/layout.css"

/// Common stylesheet for all tour pages
/// TODO: split into one file per page
const css_page_common = "/style.css"

/// Sensitive defaults for any page
const css_defaults_page = [css_fonts, css_theme, css__gleam_common, css_layout]

// Defines code syntax highlighting for highlightJS & CodeFlash
// based on dark / light mode and the currenly loaded color scheme
const css_syntax_highlight = "/css/code/syntax-highlight.css"

// Color schemes
// TODO: add more color schemes

/// Atom One Dark & Atom One Light colors
const css_scheme_atom_one = "/css/code/color-schemes/atom-one.css"

/// Sensitive defaults for any page needing to display Gleam code
/// To be used alonside defaults_page
const css_defaults_code = [css_syntax_highlight, css_scheme_atom_one]

pub fn main() {
  let result = {
    use _ <- result.try(reset_output())
    use _ <- result.try(make_prelude_available())
    use _ <- result.try(make_stdlib_available())
    use _ <- result.try(copy_wasm_compiler())
    use p <- result.try(load_content())
    use _ <- result.try(write_content(p))
    Ok(Nil)
  }

  case result {
    Ok(_) -> {
      io.println("Site compiled to ./public 🎉")
    }
    Error(snag) -> {
      panic as snag.pretty_print(snag)
    }
  }
}

pub type Chapter {
  Chapter(name: String, path: String, lessons: List(Lesson))
}

pub type Lesson {
  Lesson(
    name: String,
    text: String,
    code: String,
    path: String,
    previous: Option(String),
    next: Option(String),
  )
}

type FileNames {
  FileNames(path: String, name: String, slug: String)
}

fn load_directory_names(path: String) -> snag.Result(List(FileNames)) {
  use files <- result.map(
    simplifile.read_directory(path)
    |> file_error("Failed to read directory " <> path),
  )
  files
  |> list.sort(by: string.compare)
  |> list.filter(fn(file) { !string.starts_with(file, ".") })
  |> list.map(fn(file) {
    let path = path <> "/" <> file
    let slug =
      file
      |> string.split("_")
      |> list.drop(1)
      |> string.join("-")
    let name =
      slug
      |> string.replace("-", " ")
      |> string.capitalise
    FileNames(path: path, name: name, slug: slug)
  })
}

fn load_chapter(names: FileNames) -> snag.Result(Chapter) {
  let path = "/" <> names.slug
  use lessons <- result.try(load_directory_names(names.path))
  use lessons <- result.try(list.try_map(lessons, load_lesson(path, _)))
  Ok(Chapter(name: names.name, path: path, lessons: lessons))
}

fn read_file(path: String) -> snag.Result(String) {
  simplifile.read(path)
  |> file_error("Failed to read file " <> path)
}

fn load_lesson(chapter_path: String, names: FileNames) -> snag.Result(Lesson) {
  use code <- result.try(read_file(names.path <> "/code.gleam"))
  use text <- result.try(read_file(names.path <> "/en.html"))

  Ok(Lesson(
    name: names.name,
    text: text,
    code: code,
    path: chapter_path <> "/" <> names.slug,
    previous: None,
    next: None,
  ))
}

fn load_content() -> snag.Result(List(Chapter)) {
  use chapters <- result.try(load_directory_names(content_path))
  use chapters <- result.try(list.try_map(chapters, load_chapter))
  Ok(add_prev_next(chapters, [], path_home))
}

fn write_content(chapters: List(Chapter)) -> snag.Result(Nil) {
  let lessons = list.flat_map(chapters, fn(c) { c.lessons })
  use _ <- result.try(list.try_map(lessons, write_lesson))

  let assert Ok(first) = list.first(lessons)
  let assert Ok(last) = list.last(lessons)

  // Home page
  use _ <- result.try(
    write_lesson(Lesson(
      name: "Welcome to the Gleam language tour! 💫",
      text: home_html,
      code: hello_joe,
      path: path_home,
      previous: None,
      next: Some(first.path),
    )),
  )

  // "What next" final page
  use _ <- result.try(
    write_lesson(Lesson(
      name: "What next? ✨",
      text: what_next_html,
      code: hello_mike,
      path: path_what_next,
      previous: Some(last.path),
      next: None,
    )),
  )

  // Lesson contents page
  use _ <- result.try(
    write_lesson(Lesson(
      name: "Table of Contents",
      text: string.join(list.map(chapters, contents_list_html), "\n"),
      code: hello_joe,
      path: path_table_of_contents,
      previous: None,
      next: None,
    )),
  )

  // Everything page
  use _ <- result.try(write_everything_page(chapters))

  Ok(Nil)
}

fn contents_list_html(chapter: Chapter) -> String {
  string.concat([
    render_html(h("h3", [#("class", "mb-0")], [text(chapter.name)])),
    render_html(h(
      "ul",
      [],
      list.map(chapter.lessons, fn(lesson) {
        h("li", [], [
          h("a", [#("href", lesson.path)], [
            lesson.name
            |> string.replace("-", " ")
            |> string.capitalise
            |> text,
          ]),
        ])
      }),
    )),
  ])
}

fn render_html(html: htmb.Html) -> String {
  html
  |> htmb.render
  |> string_builder.to_string
}

fn ensure_directory(path: String) -> snag.Result(Nil) {
  simplifile.create_directory_all(path)
  |> file_error("Failed to create directory " <> path)
}

fn write_text(path: String, text: String) -> snag.Result(Nil) {
  simplifile.write(path, text)
  |> file_error("Failed to write " <> path)
}

fn write_everything_page(chapters: List(Chapter)) -> snag.Result(Nil) {
  let path = public <> "/everything"
  use _ <- result.try(ensure_directory(path))
  let path = filepath.join(path, "/index.html")
  write_text(path, everything_page_render(chapters))
}

fn write_lesson(lesson: Lesson) -> snag.Result(Nil) {
  let path = public <> lesson.path
  use _ <- result.try(ensure_directory(path))
  let path = filepath.join(path, "/index.html")
  write_text(path, lesson_page_render(lesson))
}

fn add_prev_next(
  rest: List(Chapter),
  acc: List(Chapter),
  previous: String,
) -> List(Chapter) {
  case rest {
    [chapter1, Chapter(lessons: [next, ..], ..) as chapter2, ..rest] -> {
      let lessons = chapter1.lessons
      let #(lessons, previous) =
        add_prev_next_for_chapter(lessons, [], previous, next.path)
      let chapter1 = Chapter(..chapter1, lessons: lessons)
      add_prev_next([chapter2, ..rest], [chapter1, ..acc], previous)
    }

    [chapter, ..rest] -> {
      let lessons = chapter.lessons
      let #(lessons, previous) =
        add_prev_next_for_chapter(lessons, [], previous, path_what_next)
      let chapter = Chapter(..chapter, lessons: lessons)
      add_prev_next(rest, [chapter, ..acc], previous)
    }

    [] -> list.reverse(acc)
  }
}

fn add_prev_next_for_chapter(
  rest: List(Lesson),
  acc: List(Lesson),
  previous: String,
  last: String,
) -> #(List(Lesson), String) {
  case rest {
    [lesson1, lesson2, ..rest] -> {
      let next = lesson2.path
      let lesson = Lesson(..lesson1, previous: Some(previous), next: Some(next))
      let rest = [lesson2, ..rest]
      add_prev_next_for_chapter(rest, [lesson, ..acc], lesson.path, last)
    }
    [lesson, ..rest] -> {
      let lesson = Lesson(..lesson, previous: Some(previous), next: Some(last))
      add_prev_next_for_chapter(rest, [lesson, ..acc], lesson.path, last)
    }
    [] -> #(list.reverse(acc), previous)
  }
}

fn copy_wasm_compiler() -> snag.Result(Nil) {
  use <- require(
    simplifile.is_directory(compiler_wasm),
    "compiler-wasm must have been compiled",
  )

  simplifile.copy_directory(compiler_wasm, public <> "/compiler")
  |> file_error("Failed to copy compiler-wasm")
}

fn make_prelude_available() -> snag.Result(Nil) {
  use _ <- result.try(
    simplifile.create_directory_all(public_precompiled)
    |> file_error("Failed to make " <> public_precompiled),
  )

  simplifile.copy_file(prelude, public_precompiled <> "/gleam.mjs")
  |> file_error("Failed to copy prelude.mjs")
}

fn make_stdlib_available() -> snag.Result(Nil) {
  use files <- result.try(
    simplifile.read_directory(stdlib_sources)
    |> file_error("Failed to read stdlib directory"),
  )

  let modules =
    files
    |> list.filter(fn(file) { string.ends_with(file, ".gleam") })
    |> list.filter(fn(file) { !list.contains(skipped_stdlib_modules, file) })
    |> list.map(string.replace(_, ".gleam", ""))

  use _ <- result.try(
    generate_stdlib_bundle(modules)
    |> snag.context("Failed to generate stdlib.js bundle"),
  )

  use _ <- result.try(
    copy_compiled_stdlib(modules)
    |> snag.context("Failed to copy precompiled stdlib modules"),
  )

  use _ <- result.try(
    copy_stdlib_externals()
    |> snag.context("Failed to copy stdlib external files"),
  )

  Ok(Nil)
}

fn copy_stdlib_externals() -> snag.Result(Nil) {
  use files <- result.try(
    simplifile.read_directory(stdlib_external)
    |> file_error("Failed to read stdlib external directory"),
  )
  let files = list.filter(files, string.ends_with(_, ".mjs"))

  list.try_each(files, fn(file) {
    let from = stdlib_external <> "/" <> file
    let to = public_precompiled <> "/" <> file
    simplifile.copy_file(from, to)
    |> file_error("Failed to copy stdlib external file " <> from)
  })
}

fn copy_compiled_stdlib(modules: List(String)) -> snag.Result(Nil) {
  use <- require(
    simplifile.is_directory(stdlib_compiled),
    "Project must have been compiled for JavaScript",
  )

  let dest = public_precompiled <> "/gleam"
  use _ <- result.try(
    simplifile.create_directory_all(dest)
    |> file_error("Failed to make " <> dest),
  )

  use _ <- result.try(
    list.try_each(modules, fn(name) {
      let from = stdlib_compiled <> "/" <> name <> ".mjs"
      let to = dest <> "/" <> name <> ".mjs"
      simplifile.copy_file(from, to)
      |> file_error("Failed to copy stdlib module " <> from)
    }),
  )

  Ok(Nil)
}

fn generate_stdlib_bundle(modules: List(String)) -> snag.Result(Nil) {
  use entries <- result.try(
    list.try_map(modules, fn(name) {
      let path = stdlib_sources <> "/" <> name <> ".gleam"
      use code <- result.try(
        simplifile.read(path)
        |> file_error("Failed to read stdlib module " <> path),
      )
      let name = string.replace(name, ".gleam", "")
      let code =
        code
        |> string.replace("\\", "\\\\")
        |> string.replace("`", "\\`")
        |> string.split("\n")
        |> list.filter(fn(line) { !string.starts_with(string.trim(line), "//") })
        |> list.filter(fn(line) {
          !string.starts_with(line, "@external(erlang")
        })
        |> list.filter(fn(line) { line != "" })
        |> string.join("\n")

      Ok("  \"gleam/" <> name <> "\": `" <> code <> "`")
    }),
  )

  entries
  |> string.join(",\n")
  |> string.append("export default {\n", _)
  |> string.append("\n}\n")
  |> simplifile.write(public <> "/stdlib.js", _)
  |> file_error("Failed to write stdlib.js")
}

fn reset_output() -> snag.Result(Nil) {
  use _ <- result.try(
    simplifile.create_directory_all(public)
    |> file_error("Failed to delete public directory"),
  )

  use files <- result.try(
    simplifile.read_directory(public)
    |> file_error("Failed to read public directory"),
  )

  use _ <- result.try(
    files
    |> list.map(string.append(public <> "/", _))
    |> simplifile.delete_all
    |> file_error("Failed to delete public directory"),
  )

  simplifile.copy_directory(static, public)
  |> file_error("Failed to copy static directory")
}

fn require(
  that condition: Bool,
  because reason: String,
  then next: fn() -> snag.Result(t),
) -> snag.Result(t) {
  case condition {
    True -> next()
    False -> Error(snag.new(reason))
  }
}

fn file_error(
  result: Result(t, simplifile.FileError),
  context: String,
) -> snag.Result(t) {
  case result {
    Ok(value) -> Ok(value)
    Error(error) ->
      snag.error("File error: " <> string.inspect(error))
      |> snag.context(context)
  }
}

// Page renders

/// Renders the navbar with common links
fn navbar_render() -> Html {
  widgets.navbar(titled: "Gleam Language Tour", links: [
    // TODO: find better label
    Link(label: "Tour index", to: path_everything),
    Link(label: "gleam.run", to: "http://gleam.run"),
  ])
}

/// Renders a Lesson's page
/// Complete with title, lesson, editor and output
fn lesson_page_render(lesson: Lesson) -> String {
  let navlink = fn(name, link) {
    case link {
      None -> h("span", [], [text(name)])
      Some(path) -> h("a", [#("href", path)], [text(name)])
    }
  }

  render.render(PageConfig(
    path: lesson.path,
    title: lesson.name,
    stylesheets: list.flatten([
      css_defaults_page,
      css_defaults_code,
      [css_page_common],
    ]),
    static_content: [navbar_render()],
    content: [
      h("article", [#("id", "playground")], [
        h("section", [#("id", "left")], [
          h("h2", [], [text(lesson.name)]),
          htmb.dangerous_unescaped_fragment(string_builder.from_string(
            lesson.text,
          )),
          h("nav", [#("class", "prev-next")], [
            navlink("Back", lesson.previous),
            text(" — "),
            h("a", [#("href", path_table_of_contents)], [text("Contents")]),
            text(" — "),
            navlink("Next", lesson.next),
          ]),
        ]),
        h("section", [#("id", "right")], [
          h("section", [#("id", "editor")], [
            h("div", [#("id", "editor-target")], []),
          ]),
          h("aside", [#("id", "output")], []),
        ]),
      ]),
    ],
    scripts: ScriptConfig(
      body: [
        render.dangerous_inline_script(
          widgets.theme_picker_js,
          render.ScriptOptions(module: True, defer: False),
          [],
        ),
        h("script", [#("type", "gleam"), #("id", "code")], [
          htmb.dangerous_unescaped_fragment(string_builder.from_string(
            lesson.code,
          )),
        ]),
        render.script(
          "/index.js",
          render.ScriptOptions(module: True, defer: False),
          [],
        ),
      ],
      head: [],
    ),
  ))
}

/// Transform a path into a slug
fn slugify_path(path: String) -> String {
  string.replace(path, "/", "-")
  |> string.drop_left(up_to: 1)
}

/// Renders a lesson item in the everyting page's list
fn everything_page_lesson_html(lesson: Lesson, index: Int, end_index: Int) {
  let snippet_link_title = "Experiment with " <> lesson.name <> " in browser"

  let lesson_content =
    h("article", [#("class", "lesson"), #("id", slugify_path(lesson.path))], [
      h("a", [#("href", "#" <> slugify_path(lesson.path)), #("class", "link")], [
        h("h2", [#("class", "lesson-title")], [text(lesson.name)]),
      ]),
      htmb.dangerous_unescaped_fragment(string_builder.from_string(lesson.text)),
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
    _ -> [lesson_content, widgets.separator("lesson")]
  }
}

/// Renders a list containing all chapters and their lessons
fn everything_page_chapters_html(chapters: List(Chapter)) -> List(Html) {
  use #(chapter, index) <- list.flat_map(
    list.index_map(chapters, fn(chap, i) { #(chap, i) }),
  )

  let lessons =
    list.index_map(chapter.lessons, fn(lesson, index) {
      everything_page_lesson_html(
        lesson,
        index,
        list.length(chapter.lessons) - 1,
      )
    })
  let chapter_title =
    h("h3", [#("id", slugify_path(chapter.path)), #("class", "chapter-title")], [
      text(chapter.name),
    ])

  let chapter_header = case index {
    0 -> [chapter_title, widgets.separator("chapter")]
    _ -> [
      widgets.separator("chapter-between"),
      chapter_title,
      widgets.separator("chapter"),
    ]
  }

  list.concat([chapter_header, ..lessons])
}

/// Renders a link to a lesson in the table of contents
fn everything_page_toc_link(lesson: Lesson) -> Html {
  h("li", [], [
    widgets.text_link(
      Link(label: lesson.name, to: "#" <> slugify_path(lesson.path)),
      [#("class", "link padded")],
    ),
  ])
}

/// Renders the everything pages's table of contents
fn everything_page_toc_html(chapters: List(Chapter)) -> List(Html) {
  use chapter <- list.map(chapters)
  let links = list.map(chapter.lessons, everything_page_toc_link)

  h("article", [#("class", "chapter"), #("id", "chapter-" <> chapter.name)], [
    h("h3", [], [text(chapter.name)]),
    h("ul", [], links),
  ])
}

/// Renders the /everything's page body content
fn everything_page_html(chapters: List(Chapter)) -> Html {
  let chapter_lessons = everything_page_chapters_html(chapters)
  let table_of_contents = everything_page_toc_html(chapters)

  h("main", [#("id", "everything")], [
    h(
      "aside",
      [#("id", "everything-contents"), #("class", "dim-bg")],
      table_of_contents,
    ),
    h("section", [#("id", "everything-lessons")], chapter_lessons),
  ])
}

// Path to the css specific to the everything page
const css_everything_page = "/css/pages/everything.css"

/// Renders the /everything page to a string
pub fn everything_page_render(chapters: List(Chapter)) -> String {
  // TODO: use proper values for location and such
  render.render(PageConfig(
    path: path_everything,
    title: "Everything!",
    stylesheets: list.flatten([
      css_defaults_page,
      css_defaults_code,
      [css_page_common, css_everything_page],
    ]),
    static_content: [navbar_render()],
    content: [everything_page_html(chapters)],
    scripts: ScriptConfig(
      head: [
        render.script(
          "/js/highlight/highlight.core.min.js",
          render.ScriptOptions(module: True, defer: False),
          [],
        ),
        render.script(
          "/js/highlight/regexes.js",
          render.ScriptOptions(module: True, defer: True),
          [],
        ),
      ],
      body: [
        widgets.theme_picker_script(),
        render.script(
          "/js/highlight/highlight-gleam.js",
          render.ScriptOptions(module: True, defer: True),
          [],
        ),
      ],
    ),
  ))
}
