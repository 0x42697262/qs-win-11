import { test } from "node:test";
import assert from "node:assert/strict";
import { featureNameFromKey, humanize, parseListText, sectionsOf, visibleDefinitions } from "../../src/domain/settings/presentation.mjs";
import { SETTING_DEFINITIONS } from "../../src/domain/catalog/settingsSchema.mjs";

test("identifiers humanize", () => {
    assert.equal(humanize("doNotDisturb"), "Do not disturb");
    assert.equal(humanize("startMenu"), "Start menu");
    assert.equal(humanize("light"), "Light");
});

test("definitions filter by section, or by query across sections", () => {
    assert.ok(visibleDefinitions(SETTING_DEFINITIONS, "taskbar", "").every((definition) => definition.section === "taskbar"));
    const found = visibleDefinitions(SETTING_DEFINITIONS, "taskbar", "accent");
    assert.deepEqual(found.map((definition) => definition.key), ["theme.accentColor"]);
});

test("sections keep schema order", () => {
    assert.deepEqual(sectionsOf(SETTING_DEFINITIONS).slice(0, 3), ["theme", "compositor", "taskbar"]);
});

test("helpers", () => {
    assert.equal(featureNameFromKey("features.lockScreen.enabled"), "lockScreen");
    assert.deepEqual(parseListText(" foot, kitty ,,"), ["foot", "kitty"]);
});
