
export const snakeCase = /\b(?:_)*[a-z_]+[a-z\d_]+\b/g;
export const punctuation = /[\\.,\(\):\[\]{}#]/g;
export const endParenthesis = /\(/g;
export const importModule = /(?<=import )\b(?:_)*[a-z_]+[a-z\d_]+\b/g
export const functionCall = /\b(?:_)*[a-z_]+[a-z\d_]+\b(?=\()/g;
export const functionParam = /(?<=\b(?:_)*[a-z_]+[a-z\d_]+\b\()(.|\s|\n)*(?=\))/g;
export const operator = /(<<|>>|<-|->|\|>|<>|\.\.|<=\.?|>=\.?|==\.?|!=\.?|<\.?|>\.?|&&|\|\||\+\.?|-\.?|\/\.?|\*\.?|%\.?|=)/g;
export const type = /\b[A-Z]{1}(?:[a-z]+[A-Z]{0,1})*\b/g;
export const literal = /\b(True|False|Nil)\b/g;
export const comment = /\/\/.*/g;
export const attribute = /@[a-zA-Z0-9]+\b(?=\()/g;
export const discardName = /\b_[a-z][a-z0-9_]*\b/g;
export const number = {
    binary: "\\b0[bB](?:_?[01]+)+",
    octal: "\\b0[oO](?:_?[0-7]+)+",
    hex: "\\b0[xX](?:_?[0-9a-fA-F]+)+",
    decOrFloat: /\b\d(?:_?\d+)*(?:\.(?:\d(?:_?\d+)*)*)?/g,
    scientific: /(?:(?:-\d)|\d)(?:_?\d+)*(?:\.(?:\d(?:_?\d+)*)*)?e(?:(?:-\d)|\d)(?:_?\d+)*(?:\.(?:\d(?:_?\d+)*)*)?/g
}