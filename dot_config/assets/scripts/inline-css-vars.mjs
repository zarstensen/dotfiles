import postcss from "postcss";
import { inlineCssVars } from "postcss-inline-css-vars";
import atImport from "postcss-import";
import postcssPresetEnv from "postcss-preset-env";
import fs from "fs";
import path from "path";

const css_in = process.argv[2];
const css_out = process.argv[3];

if (!css_in || !css_out) {
    console.error("Usage: node inline-vars.mjs <css_file_in> <css_file_out>");
    process.exit(1);
}

const inPath = path.resolve(css_in);
const outPath = path.resolve(css_out);

let debounceTimer = null;
const DEBOUNCE_MS = 100;

async function processCss() {
    try {
        const css = fs.readFileSync(inPath, "utf8");
        const result = await postcss()
            .use(atImport())
            .use(inlineCssVars())
            .use(postcssPresetEnv())
            .process(css, { from: inPath });
        fs.writeFileSync(outPath, result.css, "utf8");
        console.log(new Date().toISOString(), "Processed:", inPath, "->", outPath);
    } catch (err) {
        console.error("Error processing CSS:", err);
    }
}

// initial run
await processCss();

console.log("Watching", inPath, "for changes...");

try {
    const watcher = fs.watch(inPath, (eventType) => {
        // Some editors trigger multiple events; debounce them
        if (debounceTimer) clearTimeout(debounceTimer);
        debounceTimer = setTimeout(async () => {
            debounceTimer = null;
            // If file was removed/renamed, try to handle gracefully
            if (!fs.existsSync(inPath)) {
                console.warn("Source file no longer exists:", inPath);
                return;
            }
            await processCss();
        }, DEBOUNCE_MS);
    });

    // keep process running
    watcher.on("error", (err) => {
        console.error("Watcher error:", err);
    });
} catch (err) {
    console.error("Failed to watch file:", err);
    process.exit(1);
}
