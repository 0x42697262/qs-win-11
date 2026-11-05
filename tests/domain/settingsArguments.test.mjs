import { test } from "node:test";
import assert from "node:assert/strict";
import { defaultValueFor, formatValueAt, parseValueArgument } from "../../src/domain/ipc/settingsArguments.mjs";

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
