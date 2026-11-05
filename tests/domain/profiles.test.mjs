import { test } from "node:test";
import assert from "node:assert/strict";
import { conditionsMatch, filterProfileOverrides, mergeLayers, overridesForSections, parseProfileMeta, resolveProfilePaths, withinTimeRange } from "../../src/domain/profiles/layers.mjs";
import { buildValues } from "../../src/domain/settings/document.mjs";
import { SETTINGS_DOCUMENT_SCHEMA } from "../../src/domain/catalog/schemas.mjs";

test("later layers win and the user wins last, with sources", () => {
    const result = mergeLayers([
        { name: "icons", overrides: { "icons.grid": "fluent:apps_24", "theme.mode": "light" } },
        { name: "night", overrides: { "theme.mode": "dark" } },
    ], { "taskbar.alignment": "left" });
    assert.equal(result.merged["theme.mode"], "dark");
    assert.deepEqual(result.sources["theme.mode"], { kind: "profile", name: "night" });
    assert.deepEqual(result.sources["taskbar.alignment"], { kind: "user", name: "" });
    const values = /** @type {any} */ (buildValues(SETTINGS_DOCUMENT_SCHEMA, result.merged));
    assert.equal(values.icons.grid, "fluent:apps_24");
    assert.equal(values.clock.use24Hour, false);
});

test("profiles cannot set profile keys, and commands need trust", () => {
    const overrides = { "profiles.active": ["x"], "commands.lock": "rm", "theme.mode": "light" };
    const untrusted = filterProfileOverrides(overrides, false);
    assert.deepEqual(Object.keys(untrusted.overrides), ["theme.mode"]);
    assert.deepEqual(untrusted.problems.map((problem) => problem.problem), ["notAllowedInProfile", "commandsNotTrusted"]);
    assert.ok("commands.lock" in filterProfileOverrides(overrides, true).overrides);
});

test("relative paths resolve against the profile folder", () => {
    const resolved = resolveProfilePaths({ "wallpaper.path": "./wall.jpg", "icons.grid": "image:./start.svg", "icons.search": "fluent:search_24" }, "/p/neon");
    assert.equal(resolved["wallpaper.path"], "/p/neon/wall.jpg");
    assert.equal(resolved["icons.grid"], "image:/p/neon/start.svg");
    assert.equal(resolved["icons.search"], "fluent:search_24");
});

test("conditions: battery, theme and time ranges", () => {
    const context = { onBattery: true, theme: "dark", minutesNow: 23 * 60 };
    assert.ok(conditionsMatch(null, context));
    assert.ok(conditionsMatch({ onBattery: true, theme: "dark", between: "19:00-07:00" }, context));
    assert.equal(conditionsMatch({ onBattery: false }, context), false);
    assert.ok(withinTimeRange("09:00-17:00", 10 * 60));
    assert.equal(withinTimeRange("broken", 0), false);
});

test("metadata parses and sections filter overrides", () => {
    assert.deepEqual(parseProfileMeta('{"description":"Night","activateWhen":{"theme":"dark"},"values":{}}'), { description: "Night", activateWhen: { theme: "dark" } });
    assert.deepEqual(parseProfileMeta("nope"), { description: "", activateWhen: null });
    assert.deepEqual(overridesForSections({ "icons.grid": "a", "colors.dark.x": "b", "profiles.active": [], "theme.mode": "c" }, ["icons", "colors"]), { "icons.grid": "a", "colors.dark.x": "b" });
});

test("top layers such as game mode win over user overrides", () => {
    const result = mergeLayers([{ name: "neon", overrides: { "a.b": 1 } }], { "a.b": 2, "c.d": 3 }, [{ name: "game", overrides: { "a.b": 0 } }]);
    assert.equal(result.merged["a.b"], 0);
    assert.equal(result.merged["c.d"], 3);
    assert.deepEqual(result.sources["a.b"], { kind: "profile", name: "game" });
});
