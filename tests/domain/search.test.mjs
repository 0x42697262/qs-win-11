import { test } from "node:test";
import assert from "node:assert/strict";
import { DEFAULTS } from "./defaults.mjs";

const SCORES = DEFAULTS.tuning;
import { alphabetGroups, rankApps, scoreApp } from "../../src/domain/search/rankApps.mjs";
import { parseRecentFiles, fileNameFromUri } from "../../src/domain/apps/recentFiles.mjs";

/** @param {string} id @param {string} name @param {string} [genericName] @param {string[]} [keywords] */
function app(id, name, genericName = "", keywords = []) {
    return { id, name, genericName, keywords };
}

test("ranking prefers exact, then prefix, then word prefix, then contains", () => {
    const apps = [app("a1", "Text Editor"), app("a2", "Terminal"), app("a3", "Extended Tools"), app("a4", "Files", "File Manager", ["folder"])];
    assert.deepEqual(rankApps(apps, "te", 5, SCORES).map((ranked) => ranked.app.name), ["Terminal", "Text Editor", "Extended Tools"]);
    assert.equal(scoreApp(app("a5", "Terminal"), "terminal", SCORES), SCORES.scoreExactName);
    assert.equal(scoreApp(apps[3] ?? app("", ""), "fold", SCORES), SCORES.scoreKeyword);
    assert.equal(rankApps(apps, "", 5, SCORES).length, 0);
});

test("alphabet groups mark first index of each letter", () => {
    assert.deepEqual(alphabetGroups([{ name: "7zip" }, { name: "Alpha" }, { name: "Arc" }, { name: "Beta" }]), [
        { letter: "#", startIndex: 0 }, { letter: "A", startIndex: 1 }, { letter: "B", startIndex: 3 },
    ]);
});

test("recent files parse, decode and sort newest first", () => {
    const xml = `<xbel>
<bookmark href="file:///home/me/old%20notes.txt" added="x" modified="2024-01-01T00:00:00Z" visited="x"></bookmark>
<bookmark href="file:///home/me/a&amp;b.pdf" modified="2025-06-01T00:00:00Z"></bookmark>
<bookmark href="https://example.com" modified="2026-01-01T00:00:00Z"></bookmark>
</xbel>`;
    const files = parseRecentFiles(xml, 5);
    assert.deepEqual(files.map((file) => file.name), ["a&b.pdf", "old notes.txt"]);
    assert.equal(fileNameFromUri("file:///tmp/x%2Fy"), "x/y");
});
