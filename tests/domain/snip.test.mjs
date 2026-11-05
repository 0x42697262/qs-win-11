import { test } from "node:test";
import assert from "node:assert/strict";
import { capturePath, fillFileCommand, gpuRecorderRegion, grimGeometry, normalizeRect, timestamp, windowAt } from "../../src/domain/capture/snip.mjs";

test("rects normalize from any drag direction", () => {
    assert.deepEqual(normalizeRect(300, 200, 100, 50), { x: 100, y: 50, width: 200, height: 150 });
});

test("geometry strings for grim and gpu-screen-recorder include the screen origin", () => {
    const rect = { x: 10, y: 20, width: 300, height: 200 };
    assert.equal(grimGeometry(rect, 1920, 0), "1930,20 300x200");
    assert.equal(gpuRecorderRegion(rect, 1920, 0), "300x200+1930+20");
    assert.equal(grimGeometry({ x: 0, y: 0, width: 0, height: 0 }, 0, 0), "0,0 1x1");
});

test("capture paths use a sortable timestamp", () => {
    const date = new Date(2026, 10, 5, 7, 3, 9);
    assert.equal(timestamp(date), "2026-11-05_07-03-09");
    assert.equal(capturePath("/p", "Screenshot_{timestamp}.png", date), "/p/Screenshot_2026-11-05_07-03-09.png");
});

test("window hit testing and file commands", () => {
    const windows = [{ id: "a", x: 0, y: 0, width: 100, height: 100 }, { id: "b", x: 100, y: 0, width: 100, height: 100 }];
    assert.equal(windowAt(windows, 150, 50)?.id, "b");
    assert.equal(windowAt(windows, 250, 50), null);
    assert.equal(fillFileCommand("swappy -f {file}", "/tmp/it's.png"), "swappy -f '/tmp/it'\\''s.png'");
});

test("recorder choice and commands", async () => {
    const { pickRecorder, recorderCommand } = await import("../../src/domain/capture/snip.mjs");
    assert.equal(pickRecorder("auto", { gpu: false, wf: true }), "wf-recorder");
    assert.equal(pickRecorder("auto", { gpu: true, wf: true }), "gpu-screen-recorder");
    assert.equal(pickRecorder("gpuScreenRecorder", { gpu: false, wf: true }), "");
    const screen = { x: 0, y: 0, name: "DP-1" };
    assert.deepEqual(recorderCommand("wf-recorder", { x: 1, y: 2, width: 30, height: 40 }, screen, "/r.mp4", false), ["wf-recorder", "-g", "1,2 30x40", "-f", "/r.mp4"]);
    assert.deepEqual(recorderCommand("gpu-screen-recorder", null, screen, "/r.mp4", true), ["gpu-screen-recorder", "-w", "DP-1", "-a", "default_output", "-o", "/r.mp4"]);
});
