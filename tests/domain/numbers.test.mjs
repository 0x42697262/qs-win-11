import { test } from "node:test";
import assert from "node:assert/strict";
import { clamp, roundToStep } from "../../src/domain/numbers.mjs";

test("clamp keeps values inside the range", () => {
    assert.equal(clamp(5, 0, 10), 5);
    assert.equal(clamp(-3, 0, 10), 0);
    assert.equal(clamp(42, 0, 10), 10);
});

test("roundToStep snaps to the nearest step", () => {
    assert.equal(roundToStep(37, 5), 35);
    assert.equal(roundToStep(12, 5), 10);
});
