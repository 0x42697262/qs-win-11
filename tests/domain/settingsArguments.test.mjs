import { test } from "node:test";
import assert from "node:assert/strict";
import { defaultValueFor, formatValueAt, parseValueArgument, parseValueForKey } from "../../src/domain/ipc/settingsArguments.mjs";

test("IPC values parse as JSON and fall back to text", () => {
    assert.equal(parseValueArgument("true"), true);
    assert.equal(parseValueArgument("12"), 12);
    assert.deepEqual(parseValueArgument("[\"wifi\"]"), ["wifi"]);
    assert.equal(parseValueArgument("light"), "light");
});

test("formatValueAt reads nested values by dotted key", () => {
    assert.equal(formatValueAt({ theme: { mode: "light" } }, "theme.mode"), "\"light\"");
    assert.equal(formatValueAt({ theme: { mode: "light" } }, "theme.missing"), "");
});

test("defaultValueFor finds schema defaults", () => {
    assert.equal(defaultValueFor([{ key: "alpha", defaultValue: 3 }], "alpha"), 3);
    assert.equal(defaultValueFor([], "alpha"), undefined);
});

test("list settings accept comma-separated text from the IPC command line", () => {
    const definitions = [{ key: "pins", type: "textList" }, { key: "mode", type: "enum" }];
    assert.deepEqual(parseValueForKey(definitions, "pins", "foot, kitty"), ["foot", "kitty"]);
    assert.deepEqual(parseValueForKey(definitions, "pins", "\"foot\""), ["foot"]);
    assert.equal(parseValueForKey(definitions, "mode", "light"), "light");
});
