import { test } from "node:test";
import assert from "node:assert/strict";
import { cornerPath, smoothCornerParams, smoothRectanglePath, superellipseRectanglePath } from "../../src/domain/shape/corners.mjs";

test("zero smoothing is a plain circular corner", () => {
    const params = smoothCornerParams(100, 100, 10, 0);
    assert.equal(params.extent, 10);
    assert.ok(Math.abs(params.arc - 10) < 1e-9);
    assert.ok(Math.abs(params.lead) < 1e-9 && Math.abs(params.run) < 1e-9);
});

test("iOS-like smoothing extends the curve past the radius", () => {
    const params = smoothCornerParams(200, 200, 20, 0.6);
    assert.ok(Math.abs(params.extent - 32) < 1e-9);
    assert.ok(params.lead > 0 && params.step > 0);
});

test("radius and smoothing are capped by the size", () => {
    const params = smoothCornerParams(30, 30, 40, 1);
    assert.equal(params.radius, 15);
    assert.ok(params.extent <= 15);
});

test("paths are closed and start at the top edge", () => {
    const smooth = smoothRectanglePath(100, 50, 12, 0.6);
    assert.ok(smooth.startsWith("M 80.8 0"));
    assert.ok(smooth.endsWith("Z"));
    const superellipse = superellipseRectanglePath(100, 50, 12, 5, 4);
    assert.ok(superellipse.startsWith("M 88 0"));
    assert.equal((superellipse.match(/L /g) ?? []).length, 19);
    assert.equal(cornerPath("superellipse", 100, 50, 12, { smoothing: 0.6, exponent: 5, segments: 4 }), superellipse);
});
