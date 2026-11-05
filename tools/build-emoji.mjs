import { readFileSync, writeFileSync, mkdirSync } from "node:fs";
import { dirname } from "node:path";

const SOURCE = process.argv[2];
const TARGET = new URL("../assets/emoji/emoji.json", import.meta.url).pathname;
const SKIPPED_GROUPS = new Set(["Component"]);
const VARIANT_MARKERS = ["skin tone", "hair"];
const GROUP_PREFIX = "# group: ";
const LINE_PATTERN = /^[0-9A-F ]+;\s*fully-qualified\s*#\s*(\S+)\s+E[\d.]+\s+(.+)$/;
const SCHEMA_VERSION = 1;

if (!SOURCE) {
    console.error("usage: node tools/build-emoji.mjs <emoji-test.txt>");
    process.exit(1);
}

/** @type {{ name: string, emoji: { char: string, name: string }[] }[]} */
const groups = [];
for (const line of readFileSync(SOURCE, "utf8").split("\n")) {
    if (line.startsWith(GROUP_PREFIX)) {
        groups.push({ name: line.slice(GROUP_PREFIX.length).trim(), emoji: [] });
        continue;
    }
    const match = LINE_PATTERN.exec(line);
    const group = groups[groups.length - 1];
    if (!match || !group || SKIPPED_GROUPS.has(group.name)) {
        continue;
    }
    const [, char, name] = match;
    if (VARIANT_MARKERS.some((marker) => name.includes(marker))) {
        continue;
    }
    group.emoji.push({ char, name });
}

mkdirSync(dirname(TARGET), { recursive: true });
writeFileSync(TARGET, `${JSON.stringify({ schemaVersion: SCHEMA_VERSION, source: "Unicode emoji-test.txt", groups: groups.filter((group) => group.emoji.length > 0) })}\n`);
console.log(`wrote ${TARGET}`);
