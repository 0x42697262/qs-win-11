import { test } from "node:test";
import assert from "node:assert/strict";
import { categoryOf, groupByCategory } from "../../src/domain/apps/categories.mjs";

test("freedesktop categories map to Start categories", () => {
    assert.equal(categoryOf(["GTK", "Utility", "TerminalEmulator"]), "utilities");
    assert.equal(categoryOf(["Network", "WebBrowser"]), "social");
    assert.equal(categoryOf(["Office", "Utility"]), "productivity");
    assert.equal(categoryOf([]), "other");
});

test("groups follow the category order and sort by name", () => {
    const groups = groupByCategory([
        { id: "b", name: "Zed", categories: ["Development"] },
        { id: "a", name: "Foot", categories: ["System", "TerminalEmulator"] },
        { id: "c", name: "Ark", categories: ["Development"] },
    ]);
    assert.deepEqual(groups.map((group) => [group.category, group.apps.map((app) => app.name)]), [
        ["development", ["Ark", "Zed"]],
        ["utilities", ["Foot"]],
    ]);
});
