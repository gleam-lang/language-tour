/**
 * Registers gleam as a language
 *
 * Based off https://github.com/gleam-lang/website/blob/main/javascript/highlightjs-gleam.js
 * Edited to work with minified hightlightjs core v11 (module) & match more of the syntax
 */

import hljs from "./highlight.core.min.js";
import * as regexes from "./regexes.js";

/**
 * Copies an object to prevent prototype pollution
 * @template {object} TObject - the object's structure
 * @param {TObject} obj - The source object to copy
 * @returns {TObject} - A shallow copy of the source object
 */
const cp = (obj) => ({ ...obj });

// Define operators and keywords to highlight gleam code without spawning an editor
const GLEAM_OPERATORS = [
  "<<",
  ">>",
  "<-",
  "->",
  "|>",
  "<>",
  "..",
  "<=",
  "<=.",
  ">=",
  ">=.",
  "==",
  "==.",
  "%",
  "%.",
  "!=",
  "!=.",
  "<",
  "<.",
  ">",
  ">.",
  "&&",
  "||",
  "+",
  "+.",
  "-",
  "-.",
  "/",
  "/.",
  "*",
  "*.",
  "=",
];
const GLEAM_KEYWORDS = [
  "as",
  "assert",
  "auto",
  "case",
  "const",
  "delegate",
  "derive",
  "echo",
  "else",
  "fn",
  "if",
  "implement",
  "import",
  "let",
  "macro",
  "opaque",
  "panic",
  "pub",
  "test",
  "todo",
  "type",
  "use",
];

/**
 * HLJS modes
 * Glorified regular expressions used to target & highlight code snippets
 *
 * Ordered by `relevance` -> more or less translates to parsing order / priority
 * https://highlightjs.readthedocs.io/en/stable/language-guide.html#relevance
 *
 * Their `scope` maps to 1 or more css class
 * https://highlightjs.readthedocs.io/en/stable/css-classes-reference.html
 */

// Relevance 0

const PUNCTUATION = {
  name: "punctuation",
  scope: "punctuation",
  match: regexes.punctuation,
  relevance: 0,
};

const VARIABLES = {
  scope: "variable",
  match: regexes.snakeCase,
  relevance: 0,
};

/**
 * TODO: fix regex to not break other selectors
 */
const FUNCTION_PARAM = {
  scope: "function-param",
  match: regexes.functionParam,
  relevance: 0,
};

const DISCARD_NAMES = {
  scope: "attribute",
  begin: regexes.discardName,
  relevance: 0,
};

const MODULES = {
  scope: "module",
  match: regexes.importModule,
  relevance: 0,
};

// Relevance 1

const OPERATORS = {
  scope: "operator",
  begin: regexes.operator,
  keywords: {
    operator: GLEAM_OPERATORS.join(" "),
    $pattern: /\b\S+\b/g,
  },
  relevance: 1,
};

const KEYWORDS = {
  name: "Gleam keywords",
  scope: "keyword",
  keywords: {
    keyword: GLEAM_KEYWORDS.join(" "),
    operator: GLEAM_OPERATORS.join(" "),
  },
  relevance: 1,
};

// Relevance 2

const LITERALS = {
  name: "Booleans or Nil",
  scope: "literal",
  match: regexes.literal,
  relevance: 2,
};

const NUMBERS = {
  name: "Number",
  scope: "number",
  variants: [
    {
      begin: regexes.number.binary,
    },
    {
      begin: regexes.number.octal,
    },
    {
      begin: regexes.number.hex,
    },
    {
      begin: regexes.number.decOrFloat,
    },
    {
      match: regexes.number.scientific,
    },
  ],
  relevance: 2,
};

// Relevance 3

const TYPES = {
  name: "Types & Aliases",
  scope: "type",
  match: regexes.type,
  relevance: 3,
};

// Relevance 4

const FUNCTION_CALL = {
  name: "Function calls",
  scope: "function function-name function-call",
  match: regexes.functionCall,
  relevance: 4,
};

const FUNCTION_DECLARATION = {
  name: "function declaration",
  scope: "function function-name",
  beginKeywords: "fn",
  end: regexes.endParenthesis,
  returnEnd: true,
  relevance: 4,
};

// Relevance 5

// Relevance 6

const ATTRIBUTES = {
  name: "Attributes",
  scope: "attribute",
  match: regexes.attribute,
  relevance: 6,
};

// Relevance 7

const STRINGS = {
  name: "Strings",
  scope: "string",
  variants: [{ begin: /"/, end: /"/ }],
  contains: [hljs.BACKSLASH_ESCAPE],
  relevance: 7,
};

// Relevance 8

const BIT_ARRAYS = {
  // bit array
  begin: "<<",
  end: ">>",
  scope: "operator",
  contains: [
    {
      scope: "keyword",
      beginKeywords:
        "binary bits bytes int float bit_string bit_array bits utf8 utf16 " +
        "utf32 utf8_codepoint utf16_codepoint utf32_codepoint signed " +
        "unsigned big little native unit size",
    },
    cp(KEYWORDS),
    cp(STRINGS),
    cp(VARIABLES),
    cp(DISCARD_NAMES),
    cp(NUMBERS),
    cp(PUNCTUATION),
  ],
  relevance: 8,
};

// Relevance 10

const COMMENTS = {
  name: "Comments",
  scope: "comment",
  match: regexes.comment,
  relevance: 10,
};

/**
 * Register the Gleam lang to HLJS global exported from `./highlight.core.min.js`
 */
hljs.registerLanguage("gleam", function (hljs) {
  return {
    name: "Gleam",
    aliases: ["gleam"],
    keywords: {
      keyword: KEYWORDS.keywords.keyword,
      operator: OPERATORS.keywords.operator,
    },
    contains: [
      hljs.C_LINE_COMMENT_MODE,
      cp(PUNCTUATION),
      cp(MODULES),
      cp(DISCARD_NAMES),
      cp(OPERATORS),
      cp(LITERALS),
      cp(NUMBERS),
      cp(TYPES),
      cp(FUNCTION_DECLARATION),
      cp(FUNCTION_CALL),
      cp(ATTRIBUTES),
      cp(STRINGS),
      cp(COMMENTS),
    ],
  };
});

/**
 * Wait until other scripts & css are loaded before highlighting
 */
addEventListener("DOMContentLoaded", () => {
  hljs.highlightAll();
});
