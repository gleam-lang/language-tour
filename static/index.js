import CodeFlask from "https://cdn.jsdelivr.net/npm/codeflask@1.4.1/+esm";

const output = document.querySelector("#output");
const initialCode = document.querySelector("#code").innerHTML;

const prismGrammar = {
  comment: {
    pattern: /\/\/.*/,
    greedy: true,
  },
  function: /([a-z_][a-z0-9_]+)(?=\()/,
  keyword:
    /\b(use|case|if|@external|@deprecated|fn|import|let|assert|try|pub|type|opaque|const|panic|todo|as)\b/,
  symbol: {
    pattern: /([A-Z][A-Za-z0-9_]+)/,
    greedy: true,
  },
  operator: {
    pattern:
      /(<<|>>|<-|->|\|>|<>|\.\.|<=\.?|>=\.?|==\.?|!=\.?|<\.?|>\.?|&&|\|\||\+\.?|-\.?|\/\.?|\*\.?|%\.?|=)/,
    greedy: true,
  },
  string: {
    pattern: /"((?:[^"\\]|\\.)*)"/,
    greedy: true,
  },
  module: {
    pattern: /([a-z][a-z0-9_]*)\./,
    inside: {
      punctuation: /\./,
    },
    alias: "keyword",
  },
  punctuation: /[.\\:,{}()]/,
  number:
    /\b(?:0b[0-1]+|0o[0-7]+|[[:digit:]][[:digit:]_]*(\\.[[:digit:]]*)?|0x[[:xdigit:]]+)\b/,
};

function clearOutput() {
  while (output.firstChild) {
    output.removeChild(output.firstChild);
  }
}

function appendOutput(content, className) {
  if (!content) return;
  const element = document.createElement("pre");
  element.textContent = content;
  element.className = className;
  output.appendChild(element);
}

const editor = new CodeFlask("#editor-target", {
  language: "gleam",
});
editor.addLanguage("gleam", prismGrammar);
editor.updateCode(initialCode);

function debounce(fn, delay) {
  let timer = null;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), delay);
  };
}

const worker = new Worker("worker.js", { type: "module" });

worker.onmessage = (event) => {
  const result = event.data;
  clearOutput();
  if (result.log) appendOutput(result.log, "log");
  if (result.error) appendOutput(result.error, "error");
  for (const warning of result.warnings) {
    appendOutput(warning, "warning");
  }
};

editor.onUpdate(debounce((code) => worker.postMessage(code), 200));
worker.postMessage(initialCode);
