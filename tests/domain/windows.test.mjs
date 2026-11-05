import { test } from "node:test";
import assert from "node:assert/strict";
import { makeWindowInfo, sortByMostRecentlyUsed, updateMostRecentlyUsed, windowsForMonitor } from "../../src/domain/compositor/windows.mjs";

test("most recently used order moves the active window first and drops closed ones", () => {
    assert.deepEqual(updateMostRecentlyUsed(["a1", "b2", "c3"], "c3", ["a1", "b2", "c3"]), ["c3", "a1", "b2"]);
    assert.deepEqual(updateMostRecentlyUsed(["a1", "b2"], "", ["b2", "d4"]), ["b2", "d4"]);
});

test("windows sort by most recently used, unknown ones last", () => {
    const windows = ["x1", "y2", "z3"].map((id) => makeWindowInfo({ id }));
    assert.deepEqual(sortByMostRecentlyUsed(windows, ["z3", "x1"]).map((window) => window.id), ["z3", "x1", "y2"]);
});

test("monitor filter keeps windows of that monitor and unplaced ones", () => {
    const windows = [makeWindowInfo({ id: "a1", monitorName: "DP-1" }), makeWindowInfo({ id: "b2", monitorName: "HDMI-A-1" }), makeWindowInfo({ id: "c3" })];
    assert.deepEqual(windowsForMonitor(windows, "DP-1", false).map((window) => window.id), ["a1", "c3"]);
    assert.equal(windowsForMonitor(windows, "DP-1", true).length, 3);
});

import { selectCompositorKind } from "../../src/domain/compositor/selection.mjs";

test("compositor selection detects Hyprland and falls back to generic", () => {
    assert.equal(selectCompositorKind("auto", "abc"), "hyprland");
    assert.equal(selectCompositorKind("auto", ""), "generic");
    assert.equal(selectCompositorKind("hyprland", ""), "generic");
    assert.equal(selectCompositorKind("generic", "abc"), "generic");
});
