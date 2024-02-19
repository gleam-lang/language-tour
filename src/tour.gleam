import gleam/io
import gleam/list
import htmb.{h, text}
import gleam/string_builder
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam/result
import simplifile
import filepath
import snag

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

const path_home = "/"

const page_contents = "/table-of-contents"

const path_what_next = "/what-next"

// Don't include deprecated stdlib modules
const skipped_stdlib_modules = [
  "bit_string.gleam", "bit_builder.gleam", "map.gleam",
]

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

type Chapter {
  Chapter(name: String, path: String, lessons: List(Lesson))
}

type Lesson {
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
      path: page_contents,
      previous: None,
      next: None,
    )),
  )

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

fn write_lesson(lesson: Lesson) -> snag.Result(Nil) {
  let path = public <> lesson.path
  use _ <- result.try(
    simplifile.create_directory_all(path)
    |> file_error("Failed to make " <> path),
  )

  let path = filepath.join(path, "/index.html")
  simplifile.write(to: path, contents: lesson_html(lesson))
  |> file_error("Failed to write page " <> path)
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

fn lesson_html(page: Lesson) -> String {
  let navlink = fn(name, link) {
    case link {
      None -> h("span", [], [text(name)])
      Some(path) -> h("a", [#("href", path)], [text(name)])
    }
  }

  let metaprop = fn(property, content) {
    h("meta", [#("property", property), #("content", content)], [])
  }
  let link = fn(rel, href) { h("link", [#("rel", rel), #("href", href)], []) }

  let title = page.name <> " - The Gleam Language Tour"
  let description =
    "An interactive introduction and reference to the Gleam programming language. Learn Gleam in your browser!"

  h("html", [#("lang", "en-gb")], [
    h("head", [], [
      h("meta", [#("charset", "utf-8")], []),
      h(
        "meta",
        [
          #("name", "viewport"),
          #("content", "width=device-width, initial-scale=1"),
        ],
        [],
      ),
      h("title", [], [text(title)]),
      h("meta", [#("name", "description"), #("content", description)], []),
      metaprop("og:type", "website"),
      metaprop("og:title", title),
      metaprop("og:description", description),
      metaprop("og:url", "https://tour.gleam.run/" <> page.path),
      metaprop("og:image", "https://gleam.run/images/og-image.png"),
      metaprop("twitter:card", "summary_large_image"),
      metaprop("twitter:url", "https://tour.gleam.run/" <> page.path),
      metaprop("twitter:title", title),
      metaprop("twitter:description", description),
      metaprop("twitter:image", "https://gleam.run/images/og-image.png"),
      link("shortcut icon", "https://gleam.run/images/lucy-circle.svg"),
      link("stylesheet", "/style.css"),
      h(
        "script",
        [
          #("defer", ""),
          #("data-domain", "tour.gleam.run"),
          #("src", "https://plausible.io/js/script.js"),
        ],
        [],
      ),
    ]),
    h("body", [], [
      h("nav", [#("class", "navbar")], [
        h("a", [#("href", "/")], [text("Gleam Language Tour")]),
      ]),
      h("article", [#("id", "playground")], [
        h("section", [#("id", "left")], [
          h("h2", [], [text(page.name)]),
          htmb.dangerous_unescaped_fragment(string_builder.from_string(
            page.text,
          )),
          h("nav", [#("class", "prev-next")], [
            navlink("Back", page.previous),
            text(" — "),
            h("a", [#("href", page_contents)], [text("Contents")]),
            text(" — "),
            navlink("Next", page.next),
          ]),
        ]),
        h("section", [#("id", "right")], [
          h("section", [#("id", "editor")], [
            h("div", [#("id", "editor-target")], []),
          ]),
          h("aside", [#("id", "output")], []),
        ]),
      ]),
      h("script", [#("type", "gleam"), #("id", "code")], [
        htmb.dangerous_unescaped_fragment(string_builder.from_string(page.code)),
      ]),
      h("script", [#("type", "module"), #("src", "/index.js")], []),
    ]),
  ])
  |> htmb.render_page("html")
  |> string_builder.to_string
}
