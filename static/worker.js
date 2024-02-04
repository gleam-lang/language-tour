import initGleamCompiler from "./compiler.js";
import stdlib from "./stdlib.js";

const compiler = await initGleamCompiler();
const project = compiler.newProject();

for (const [name, code] of Object.entries(stdlib)) {
  project.writeModule(name, code);
}

// Monkey patch console.log to keep a copy of the output
let logged = "";
const log = console.log;
console.log = (...args) => {
  log(...args);
  logged += args.map((e) => `${e}`).join(" ") + "\n";
};

function resetLogCapture() {
  logged = "";
}

async function loadProgram(js) {
  const url = new URL(import.meta.url);
  url.pathname = "";
  url.hash = "";
  url.search = "";
  const href = url.toString();
  const js1 = js.replaceAll(
    /from\s+"\.\/(.+)"/g,
    `from "${href}precompiled/$1"`,
  );
  const js2 = btoa(unescape(encodeURIComponent(js1)));
  const module = await import("data:text/javascript;base64," + js2);
  return module.main;
}

async function compileEval(code) {
  const result = {
    log: null,
    error: null,
    warnings: [],
  };

  try {
    project.writeModule("main", code);
    project.compilePackage("javascript");
    const js = project.readCompiledJavaScript("main");
    const main = await loadProgram(js);
    resetLogCapture();
    if (main) main();
  } catch (error) {
    console.error(error);
    result.error = error.toString();
  }
  for (const warning of project.takeWarnings()) {
    result.warnings.push(warning);
  }
  result.log = logged;

  return result;
}

self.onmessage = async (event) => {
  const result = compileEval(event.data);
  postMessage(await result);
};

// Send an initial message to the main thread to indicate that the worker is
// ready to receive messages.
postMessage({});
