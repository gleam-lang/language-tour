import gleam/list
import htmb.{type Html, h, text}
import tour/render

pub fn icon_moon() -> Html {
  h("svg", [#("id", "icon-moon"), #("viewBox", "0 0 24 24")], [
    h(
      "path",
      [
        #(
          "d",
          "M21.996 12.882c0.022-0.233-0.038-0.476-0.188-0.681-0.325-0.446-0.951-0.544-1.397-0.219-0.95 0.693-2.060 1.086-3.188 1.162-1.368 0.092-2.765-0.283-3.95-1.158-1.333-0.985-2.139-2.415-2.367-3.935s0.124-3.124 1.109-4.456c0.142-0.191 0.216-0.435 0.191-0.691-0.053-0.55-0.542-0.952-1.092-0.898-2.258 0.22-4.314 1.18-5.895 2.651-1.736 1.615-2.902 3.847-3.137 6.386-0.254 2.749 0.631 5.343 2.266 7.311s4.022 3.313 6.772 3.567 5.343-0.631 7.311-2.266 3.313-4.022 3.567-6.772zM19.567 14.674c-0.49 1.363-1.335 2.543-2.416 3.441-1.576 1.309-3.648 2.016-5.848 1.813s-4.108-1.278-5.417-2.854-2.016-3.648-1.813-5.848c0.187-2.032 1.117-3.814 2.507-5.106 0.782-0.728 1.71-1.3 2.731-1.672-0.456 1.264-0.577 2.606-0.384 3.899 0.303 2.023 1.38 3.934 3.156 5.247 1.578 1.167 3.448 1.668 5.272 1.545 0.752-0.050 1.496-0.207 2.21-0.465z",
        ),
      ],
      [],
    ),
  ])
}

pub fn icon_sun() -> Html {
  h("svg", [#("id", "icon-sun"), #("viewBox", "0 0 24 24")], [
    h(
      "path",
      [
        #(
          "d",
          "M18 12c0-1.657-0.673-3.158-1.757-4.243s-2.586-1.757-4.243-1.757-3.158 0.673-4.243 1.757-1.757 2.586-1.757 4.243 0.673 3.158 1.757 4.243 2.586 1.757 4.243 1.757 3.158-0.673 4.243-1.757 1.757-2.586 1.757-4.243zM16 12c0 1.105-0.447 2.103-1.172 2.828s-1.723 1.172-2.828 1.172-2.103-0.447-2.828-1.172-1.172-1.723-1.172-2.828 0.447-2.103 1.172-2.828 1.723-1.172 2.828-1.172 2.103 0.447 2.828 1.172 1.172 1.723 1.172 2.828zM11 1v2c0 0.552 0.448 1 1 1s1-0.448 1-1v-2c0-0.552-0.448-1-1-1s-1 0.448-1 1zM11 21v2c0 0.552 0.448 1 1 1s1-0.448 1-1v-2c0-0.552-0.448-1-1-1s-1 0.448-1 1zM3.513 4.927l1.42 1.42c0.391 0.391 1.024 0.391 1.414 0s0.391-1.024 0-1.414l-1.42-1.42c-0.391-0.391-1.024-0.391-1.414 0s-0.391 1.024 0 1.414zM17.653 19.067l1.42 1.42c0.391 0.391 1.024 0.391 1.414 0s0.391-1.024 0-1.414l-1.42-1.42c-0.391-0.391-1.024-0.391-1.414 0s-0.391 1.024 0 1.414zM1 13h2c0.552 0 1-0.448 1-1s-0.448-1-1-1h-2c-0.552 0-1 0.448-1 1s0.448 1 1 1zM21 13h2c0.552 0 1-0.448 1-1s-0.448-1-1-1h-2c-0.552 0-1 0.448-1 1s0.448 1 1 1zM4.927 20.487l1.42-1.42c0.391-0.391 0.391-1.024 0-1.414s-1.024-0.391-1.414 0l-1.42 1.42c-0.391 0.391-0.391 1.024 0 1.414s1.024 0.391 1.414 0zM19.067 6.347l1.42-1.42c0.391-0.391 0.391-1.024 0-1.414s-1.024-0.391-1.414 0l-1.42 1.42c-0.391 0.391-0.391 1.024 0 1.414s1.024 0.391 1.414 0z",
        ),
      ],
      [],
    ),
  ])
}

pub fn icon_toggle_left() -> Html {
  h("svg", [#("id", "icon-toggle-left"), #("viewBox", "0 0 24 24")], [
    h(
      "path",
      [
        #(
          "d",
          "M8 4c-2.209 0-4.21 0.897-5.657 2.343s-2.343 3.448-2.343 5.657 0.897 4.21 2.343 5.657 3.448 2.343 5.657 2.343h8c2.209 0 4.21-0.897 5.657-2.343s2.343-3.448 2.343-5.657-0.897-4.21-2.343-5.657-3.448-2.343-5.657-2.343zM8 6h8c1.657 0 3.156 0.67 4.243 1.757s1.757 2.586 1.757 4.243-0.67 3.156-1.757 4.243-2.586 1.757-4.243 1.757h-8c-1.657 0-3.156-0.67-4.243-1.757s-1.757-2.586-1.757-4.243 0.67-3.156 1.757-4.243 2.586-1.757 4.243-1.757zM12 12c0-1.104-0.449-2.106-1.172-2.828s-1.724-1.172-2.828-1.172-2.106 0.449-2.828 1.172-1.172 1.724-1.172 2.828 0.449 2.106 1.172 2.828 1.724 1.172 2.828 1.172 2.106-0.449 2.828-1.172 1.172-1.724 1.172-2.828zM10 12c0 0.553-0.223 1.051-0.586 1.414s-0.861 0.586-1.414 0.586-1.051-0.223-1.414-0.586-0.586-0.861-0.586-1.414 0.223-1.051 0.586-1.414 0.861-0.586 1.414-0.586 1.051 0.223 1.414 0.586 0.586 0.861 0.586 1.414z",
        ),
      ],
      [],
    ),
  ])
}

pub fn icon_toggle_right() -> Html {
  h("svg", [#("id", "icon-toggle-right"), #("viewBox", "0 0 24 24")], [
    h(
      "path",
      [
        #(
          "d",
          "M8 4c-2.209 0-4.21 0.897-5.657 2.343s-2.343 3.448-2.343 5.657 0.897 4.21 2.343 5.657 3.448 2.343 5.657 2.343h8c2.209 0 4.21-0.897 5.657-2.343s2.343-3.448 2.343-5.657-0.897-4.21-2.343-5.657-3.448-2.343-5.657-2.343zM8 6h8c1.657 0 3.156 0.67 4.243 1.757s1.757 2.586 1.757 4.243-0.67 3.156-1.757 4.243-2.586 1.757-4.243 1.757h-8c-1.657 0-3.156-0.67-4.243-1.757s-1.757-2.586-1.757-4.243 0.67-3.156 1.757-4.243 2.586-1.757 4.243-1.757zM20 12c0-1.104-0.449-2.106-1.172-2.828s-1.724-1.172-2.828-1.172-2.106 0.449-2.828 1.172-1.172 1.724-1.172 2.828 0.449 2.106 1.172 2.828 1.724 1.172 2.828 1.172 2.106-0.449 2.828-1.172 1.172-1.724 1.172-2.828zM18 12c0 0.553-0.223 1.051-0.586 1.414s-0.861 0.586-1.414 0.586-1.051-0.223-1.414-0.586-0.586-0.861-0.586-1.414 0.223-1.051 0.586-1.414 0.861-0.586 1.414-0.586 1.051 0.223 1.414 0.586 0.586 0.861 0.586 1.414z",
        ),
      ],
      [],
    ),
  ])
}

pub fn theme_picker() -> Html {
  h("div", [#("class", "theme-picker")], [
    h(
      "button",
      [
        #("type", "button"),
        #("alt", "Switch to light mode"),
        #("title", "Switch to light mode"),
        #("class", "theme-button -light"),
        #("data-light-theme-toggle", ""),
      ],
      [icon_moon(), icon_toggle_left()],
    ),
    h(
      "button",
      [
        #("type", "button"),
        #("alt", "Switch to dark mode"),
        #("title", "Switch to dark mode"),
        #("class", "theme-button -dark"),
        #("data-dark-theme-toggle", ""),
      ],
      [icon_sun(), icon_toggle_right()],
    ),
  ])
}

// This script is inlined in the response to avoid FOUC when applying the theme
pub const theme_picker_js = "
const mediaPrefersDarkTheme = window.matchMedia('(prefers-color-scheme: dark)')

function selectTheme(selectedTheme) {
  // Apply and remember the specified theme.
  applyTheme(selectedTheme)
  if ((selectedTheme === 'dark') === mediaPrefersDarkTheme.matches) {
    // Selected theme is the same as the device's preferred theme, so we can forget this setting.
    localStorage.removeItem('theme')
  } else {
    // Remember the selected theme to apply it on the next visit
    localStorage.setItem('theme', selectedTheme)
  }
}

function applyTheme(theme) {
  document.documentElement.classList.toggle('theme-dark', theme === 'dark')
  document.documentElement.classList.toggle('theme-light', theme !== 'dark')
}

// If user had selected a theme, load it. Otherwise, use device's preferred theme
const selectedTheme = localStorage.getItem('theme')
if (selectedTheme) {
  applyTheme(selectedTheme)
} else {
  applyTheme(mediaPrefersDarkTheme.matches ? 'dark' : 'light')
}

// Watch the device's preferred theme and update theme if user did not select a theme
mediaPrefersDarkTheme.addEventListener('change', () => {
  const selectedTheme = localStorage.getItem('theme')
  if (!selectedTheme) {
    applyTheme(mediaPrefersDarkTheme.matches ? 'dark' : 'light')
  }
})

// Add handlers for theme selection buttons.
document.querySelector('[data-light-theme-toggle]').addEventListener('click', () => {
  selectTheme('light')
})
document.querySelector('[data-dark-theme-toggle]').addEventListener('click', () => {
  selectTheme('dark')
})
"

pub fn theme_picker_script() -> Html {
  render.dangerous_inline_script(
    theme_picker_js,
    render.ScriptOptions(module: True, defer: False),
    [],
  )
}

/// Renders an HTML anhor tag
pub fn anchor(
  to href: String,
  attrs attributes: List(#(String, String)),
  with content: List(Html),
) -> Html {
  h("a", [#("href", href), ..attributes], content)
}

pub type Link {
  Link(label: String, to: String)
}

/// Renders a styled text link
pub fn text_link(
  for link: Link,
  attributes attributes: List(#(String, String)),
) -> Html {
  let link_attributes = [#("class", "link"), ..attributes]

  anchor(link.to, link_attributes, [text(link.label)])
}

/// Renders the tour's navbar as html
pub fn navbar(titled title: String, links links: List(Link)) -> Html {
  let links = list.map(links, fn(l) { text_link(l, []) })

  let nav_right_items = list.flatten([links, [theme_picker()]])

  h("nav", [#("class", "navbar")], [
    anchor("/", [#("class", "logo")], [
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

/// Renders a horizontal separator
pub fn separator(class: String) -> Html {
  h("hr", [#("class", class <> "-separator")], [])
}
