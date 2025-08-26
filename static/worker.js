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

async function loadProgram(js) {
  // URL to worker.js ('base/worker.js')
  const url = new URL(import.meta.url);
  // Remove 'worker.js', keep just 'base/'
  url.pathname = url.pathname.substring(0, url.pathname.lastIndexOf("/") + 1);
  url.hash = "";
  url.search = "";
  const href = url.toString();
  let editedJs = js;
  // If echo has been used then add the import to the dict module that the
  // compiler would have added if the stdlib had have been present.
  if (editedJs.includes("return value instanceof $stdlib$dict.default;")) {
    editedJs = 'import * as $stdlib$dict from "./dict.mjs";\n' + js;
  }
  // Rewrite the stdlib imports to work in this context
  editedJs = editedJs.replaceAll(
    /from\s+"\.\/(.+)"/g,
    `from "${href}precompiled/$1"`,
  );
  // Evaluate the code
  const encoded = btoa(unescape(encodeURIComponent(editedJs)));
  const module = await import("data:text/javascript;base64," + encoded);
  return module.main;
}

async function compileEval(code) {
  logged = "";
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
