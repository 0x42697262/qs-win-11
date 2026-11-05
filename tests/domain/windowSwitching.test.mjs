import { test } from "node:test";
import assert from "node:assert/strict";
import { cycleIndex, showDesktopPlan } from "../../src/domain/shell/windowSwitching.mjs";

test("cycling wraps both ways", () => {
    assert.equal(cycleIndex(0, 3, 1), 1);
    assert.equal(cycleIndex(2, 3, 1), 0);
    assert.equal(cycleIndex(0, 3, -1), 2);
    assert.equal(cycleIndex(0, 0, 1), 0);
});

test("show desktop minimizes visible windows, then restores only those", () => {
    const windows = [{ id: "a1", minimized: false }, { id: "b2", minimized: true }];
    assert.deepEqual(showDesktopPlan([], windows), { minimize: ["a1"], restore: [] });
    assert.deepEqual(showDesktopPlan(["a1"], [{ id: "a1", minimized: true }, { id: "b2", minimized: true }]), { minimize: [], restore: ["a1"] });
    assert.deepEqual(showDesktopPlan(["a1"], [{ id: "a1", minimized: false }]), { minimize: ["a1"], restore: [] });
});
