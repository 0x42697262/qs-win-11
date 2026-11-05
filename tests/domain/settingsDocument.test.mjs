import { test } from "node:test";
import assert from "node:assert/strict";
import { applyOverride, flattenValues, resolveDocument, serializeDocument } from "../../src/domain/settings/document.mjs";
import { ValidationProblem } from "../../src/domain/settings/validation.mjs";
import { SETTINGS_DOCUMENT_SCHEMA } from "../../src/domain/catalog/schemas.mjs";

const schema = SETTINGS_DOCUMENT_SCHEMA;

/** @param {Readonly<Record<string, unknown>>} values @param {string} key @returns {unknown} */
function valueAt(values, key) {
    return flattenValues({ ...values })[key];
}

test("empty document resolves to schema defaults", () => {
    const resolved = resolveDocument("", schema);
    assert.equal(resolved.problems.length, 0);
    assert.equal(valueAt(resolved.values, "theme.mode"), "dark");
    assert.equal(valueAt(resolved.values, "features.lockScreen.enabled"), false);
});

test("valid overrides apply and invalid ones fall back with a problem", () => {
    const text = JSON.stringify({ schemaVersion: 1, values: { theme: { mode: "light", scale: 9 }, taskbar: { alignment: "left" }, bogus: 1 } });
    const resolved = resolveDocument(text, schema);
    assert.equal(valueAt(resolved.values, "theme.mode"), "light");
    assert.equal(valueAt(resolved.values, "theme.scale"), 1);
    assert.equal(valueAt(resolved.values, "taskbar.alignment"), "left");
    assert.deepEqual(resolved.problems.map((problem) => [problem.key, problem.problem]), [
        ["theme.scale", ValidationProblem.OutOfRange],
        ["bogus", ValidationProblem.UnknownKey],
    ]);
});

test("unreadable JSON degrades to defaults and is flagged", () => {
    const resolved = resolveDocument("{not json", schema);
    assert.equal(valueAt(resolved.values, "theme.mode"), "dark");
    assert.equal(resolved.problems[0]?.problem, ValidationProblem.UnreadableDocument);
});

test("newer schema versions are reported but known keys still load", () => {
    const resolved = resolveDocument(JSON.stringify({ schemaVersion: 99, values: { theme: { mode: "light" } } }), schema);
    assert.equal(valueAt(resolved.values, "theme.mode"), "light");
    assert.equal(resolved.problems[0]?.problem, ValidationProblem.NewerSchemaVersion);
});

test("setting a value equal to its default removes the override", () => {
    const changed = applyOverride({}, "theme.mode", "light", schema);
    assert.ok(changed.accepted);
    const reverted = applyOverride(changed.overrides, "theme.mode", "dark", schema);
    assert.ok(reverted.accepted);
    assert.deepEqual(reverted.overrides, {});
});

test("invalid writes are rejected", () => {
    const result = applyOverride({}, "taskbar.alignment", "diagonal", schema);
    assert.equal(result.accepted, false);
});

test("serialized documents round-trip through resolve", () => {
    const changed = applyOverride({}, "clock.use24Hour", true, schema);
    assert.ok(changed.accepted);
    const resolved = resolveDocument(serializeDocument(changed.overrides, schema), schema);
    assert.equal(valueAt(resolved.values, "clock.use24Hour"), true);
    assert.equal(resolved.problems.length, 0);
});

test("every schema default passes its own validation", () => {
    for (const definition of schema.definitions) {
        const result = applyOverride({}, definition.key, definition.defaultValue, schema);
        assert.ok(result.accepted, definition.key);
    }
});
