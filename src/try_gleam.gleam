import gleam/io
import gleam/list
import htmb.{h, text}
import gleam/string_builder
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam/result
import simplifile
import snag

const static = "static"

const public = "public"

const public_precompiled = "public/precompiled"

const prelude = "build/dev/javascript/prelude.mjs"

const stdlib_compiled = "build/dev/javascript/gleam_stdlib/gleam"

const stdlib_sources = "build/packages/gleam_stdlib/src/gleam"

const stdlib_external = "build/packages/gleam_stdlib/src"

const compiler_wasm = "../gleam/compiler-wasm/pkg"

const content_path = "src/content"

const hello_joe = "import gleam/io

pub fn main() {
  io.println(\"Hello, Joe!\")
}
"

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
      io.println("Done")
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
  use text <- result.try(read_file(names.path <> "/text.html"))

  Ok(Lesson(
    name: names.name,
    text: text,
    code: code,
    path: chapter_path
    <> "/"
    <> names.slug,
    previous: None,
    next: None,
  ))
}

fn load_content() -> snag.Result(List(Chapter)) {
  use chapters <- result.try(load_directory_names(content_path))
  use chapters <- result.try(list.try_map(chapters, load_chapter))
  Ok(add_prev_next(chapters, [], Some("/")))
}

fn write_content(chapters: List(Chapter)) -> snag.Result(Nil) {
  let lessons = list.flat_map(chapters, fn(c) { c.lessons })
  use _ <- result.try(list.try_map(lessons, write_lesson))

  let html =
    chapters
    |> list.map(index_chapter_html)
    |> string.join("\n")

  let lesson =
    Lesson(
      name: "Index",
      text: html,
      code: hello_joe,
      path: "/index",
      previous: None,
      next: None,
    )
  write_lesson(lesson)
}

fn index_chapter_html(chapter: Chapter) -> String {
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

  let path = path <> "/index.html"
  simplifile.write(to: path, contents: lesson_html(lesson))
  |> file_error("Failed to write page " <> path)
}

fn add_prev_next(
  rest: List(Chapter),
  acc: List(Chapter),
  previous: Option(String),
) -> List(Chapter) {
  case rest {
    [chapter1, Chapter(lessons: [next, ..], ..) as chapter2, ..rest] -> {
      let lessons = chapter1.lessons
      let #(lessons, previous) =
        add_prev_next_for_chapter(lessons, [], previous, Some(next.path))
      let chapter1 = Chapter(..chapter1, lessons: lessons)
      add_prev_next([chapter2, ..rest], [chapter1, ..acc], previous)
    }

    [chapter, ..rest] -> {
      let lessons = chapter.lessons
      let #(lessons, previous) =
        add_prev_next_for_chapter(lessons, [], previous, None)
      let chapter = Chapter(..chapter, lessons: lessons)
      add_prev_next(rest, [chapter, ..acc], previous)
    }

    [] -> list.reverse(acc)
  }
}

fn add_prev_next_for_chapter(
  rest: List(Lesson),
  acc: List(Lesson),
  previous: Option(String),
  last: Option(String),
) -> #(List(Lesson), Option(String)) {
  case rest {
    [lesson1, lesson2, ..rest] -> {
      let next = Some(lesson2.path)
      let lesson = Lesson(..lesson1, previous: previous, next: next)
      let rest = [lesson2, ..rest]
      add_prev_next_for_chapter(rest, [lesson, ..acc], Some(lesson.path), last)
    }
    [lesson, ..rest] -> {
      let lesson = Lesson(..lesson, previous: previous, next: last)
      add_prev_next_for_chapter(rest, [lesson, ..acc], Some(lesson.path), last)
    }
    [] -> #(list.reverse(acc), previous)
  }
}

fn copy_wasm_compiler() -> snag.Result(Nil) {
  use <- require(
    simplifile.is_directory(compiler_wasm),
    "compiler-wasm/pkg must have been compiled",
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
      h("title", [], [text("Try Gleam")]),
      h("link", [#("rel", "stylesheet"), #("href", "/style.css")], []),
    ]),
    h("body", [], [
      h("nav", [#("class", "navbar")], [
        h("a", [#("href", "/")], [text("Try Gleam")]),
      ]),
      h("article", [#("id", "playground")], [
        h("section", [#("id", "left")], [
          htmb.dangerous_unescaped_fragment(string_builder.from_string(page.text,
          )),
          h("nav", [#("class", "prev-next")], [
            navlink("Back", page.previous),
            text(" — "),
            h("a", [#("href", "/index")], [text("Index")]),
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
