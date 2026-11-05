import { test } from "node:test";
import assert from "node:assert/strict";
import { hyprlandPlacementCommands, placementRect } from "../../src/domain/snap/placement.mjs";
import { SNAP_LAYOUTS } from "../../src/domain/catalog/snapLayouts.mjs";

const monitor = { x: 0, y: 0, width: 1920, height: 1080, scale: 1, reserved: [0, 0, 0, 48] };

test("zones map to the usable area with gaps", () => {
    assert.deepEqual(placementRect(monitor, { x: 0, y: 0, width: 0.5, height: 1 }, 8), { x: 4, y: 4, width: 952, height: 1024 });
    assert.deepEqual(placementRect({ ...monitor, x: 1920, scale: 2, reserved: [0, 0, 0, 0] }, { x: 0.5, y: 0.5, width: 0.5, height: 0.5 }, 0), { x: 2400, y: 270, width: 480, height: 270 });
});

test("every layout covers the screen width", () => {
    for (const layout of SNAP_LAYOUTS) {
        const right = Math.max(...layout.zones.map((zone) => zone.x + zone.width));
        assert.ok(Math.abs(right - 1) < 1e-9, layout.name);
    }
});

test("placement commands in classic and Lua syntax", () => {
    const rect = { x: 4, y: 4, width: 952, height: 1024 };
    assert.deepEqual(hyprlandPlacementCommands("0xabc", rect, false, false), [
        "setfloating address:0xabc",
        "resizewindowpixel exact 952 1024,address:0xabc",
        "movewindowpixel exact 4 4,address:0xabc",
    ]);
    assert.equal(hyprlandPlacementCommands("abc", rect, false, true)[0], "resizewindowpixel exact 952 1024,address:0xabc");
    const lua = hyprlandPlacementCommands("0xabc", rect, true, true);
    assert.equal(lua.length, 2);
    assert.equal(lua[1], "hl.dsp.window.move({ x = 4, y = 4, relative = false, window = \"address:0xabc\" })");
});
