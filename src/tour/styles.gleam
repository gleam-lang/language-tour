//// A list of valid paths to static css files
//// We use these to pick and choose what style sheets to include per page

/// Inherited from code Gleam projects
pub const common = "/common.css"

/// Loads fonts and defines font sizes
pub const fonts = "/css/fonts.css"

/// Derives app colors for both dark & light themes from common.css variables
pub const theme = "/css/theme.css"

/// Defines layout unit variables
pub const layout = "/css/layout.css"

/// Common stylesheet for all tour pages
/// TODO: split into one file per page
pub const page = "/style.css"

/// Sensitive defaults for any page
pub const defaults_page = [theme, fonts, common, layout]

// Defines code syntax highlighting for highlightJS & CodeFlash
// based on dark / light mode and the currenly loaded color scheme
pub const syntax_highlight = "/css/code/syntax-highlight.css"

// Color schemes
// TODO: add more color schemes

/// Atom One Dark & Atom One Light colors
pub const scheme_atom_one = "/css/code/color-schemes/atom-one.css"

/// Sensitive defaults for any page needing to display Gleam code
/// To be used alonside defaults_page
pub const defaults_code = [syntax_highlight, scheme_atom_one]
