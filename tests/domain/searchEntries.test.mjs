import { test } from "node:test";
import assert from "node:assert/strict";
import { rememberCommand } from "../../src/domain/search/runHistory.mjs";
import { buildSearchEntries, rankSettings, SearchEntryKind } from "../../src/domain/search/searchEntries.mjs";
import { SETTING_DEFINITIONS } from "../../src/domain/catalog/settingsSchema.mjs";

const definitions = [
    { key: "theme.mode", label: "Theme mode", description: "Light, dark or auto.", section: "theme" },
    { key: "taskbar.alignment", label: "Taskbar alignment", description: "Center or left.", section: "taskbar" },
    { key: "colors.dark.accent", label: "Accent (dark)", description: "Accent color in dark mode.", section: "colors" },
];

test("settings rank label starts before word starts before descriptions", () => {
    assert.deepEqual(rankSettings(definitions, "dark", 10, 2).map(definition => definition.key), ["colors.dark.accent", "theme.mode"]);
    assert.deepEqual(rankSettings(definitions, "ta", 10, 2).map(definition => definition.key), ["taskbar.alignment"]);
    assert.deepEqual(rankSettings(definitions, "t", 10, 2), []);
    assert.deepEqual(rankSettings(definitions, "theme", 0, 2), []);
});

test("real schema finds the theme mode setting", () => {
    assert.ok(rankSettings(SETTING_DEFINITIONS, "theme mode", 4, 2).some(definition => definition.key === "theme.mode"));
});

test("entries put the calculation first, then apps, then settings", () => {
    const entries = buildSearchEntries({ expression: "1+1", value: 2, display: "2" }, [{ id: "foot", name: "Foot" }], [definitions[0]]);
    assert.deepEqual(entries.map(entry => entry.kind), [SearchEntryKind.Calculation, SearchEntryKind.App, SearchEntryKind.Setting]);
    assert.equal(entries[0].title, "2");
});

test("run history keeps the newest unique commands", () => {
    assert.deepEqual(rememberCommand(["foot", "btop"], " btop ", 5), ["btop", "foot"]);
    assert.deepEqual(rememberCommand(["a1", "b1", "c1"], "d1", 2), ["d1", "a1"]);
    assert.deepEqual(rememberCommand(["a1"], "  ", 5), ["a1"]);
    assert.deepEqual(rememberCommand(["a1"], "b1", 0), []);
});
