import CodeFlask from "https://cdn.jsdelivr.net/npm/codeflask@1.4.1/+esm";

console.log(CodeFlask);
globalThis.CodeFlask = CodeFlask;

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
    pattern: /([a-z][a-z0-9_]*)\.(?!{)/,
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
  defaultTheme: false,
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

// Whether the worker is currently working or not, used to avoid sending
// multiple messages to the worker at once.
// This will be true when the worker is compiling and executing the code, but
// this first time it is as the worker is initialising.
let workerWorking = true;
let queuedWork = undefined;
const worker = new Worker("/worker.js", { type: "module" });

function sendToWorker(code) {
  if (workerWorking) {
    queuedWork = code;
    return;
  }
  workerWorking = true;
  worker.postMessage(code);
}

worker.onmessage = (event) => {
  // Handle the result of the compilation and execution
  const result = event.data;
  clearOutput();
  if (result.log) appendOutput(result.log, "log");
  if (result.error) appendOutput(result.error, "error");
  for (const warning of result.warnings || []) {
    appendOutput(warning, "warning");
  }

  // Deal with any queued work
  workerWorking = false;
  if (queuedWork) sendToWorker(queuedWork);
  queuedWork = undefined;
};

editor.onUpdate(debounce((code) => sendToWorker(code), 200));


function initLeftRightToggle() {
  const toggle = document.querySelector("#left-right-toggle");
  const btn = document.querySelector("#left-right-toggle button");
  const playground = document.querySelector("#playground");

  if (btn && toggle && right) {
    btn.addEventListener(("click"), () => {
      toggle.classList.toggle('left')
      toggle.classList.toggle('right')
      playground.classList.toggle('left')
      playground.classList.toggle('right')
    })
  }
}

initLeftRightToggle();
