import { test } from "node:test";
import assert from "node:assert/strict";
import { resolveIconSpec, EMPTY_ICON } from "../../src/domain/icons/iconSpec.mjs";

const regular = { ic_fluent_grid_24_regular: 0xf000 };
const filled = { ic_fluent_grid_24_filled: 0xf001 };
const families = { regular: "Reg", filled: "Fill" };

test("fluent specs pick the right map and family", () => {
    assert.deepEqual(resolveIconSpec("fluent:grid_24", false, regular, filled, families), { kind: "fluent", text: "", fontFamily: "Reg", source: "" });
    assert.deepEqual(resolveIconSpec("grid_24", true, regular, filled, families), { kind: "fluent", text: "", fontFamily: "Fill", source: "" });
    assert.equal(resolveIconSpec("fluent:missing", false, regular, filled, families), EMPTY_ICON);
});

test("custom font and image specs", () => {
    assert.deepEqual(resolveIconSpec("font:Material Symbols:e88a", false, regular, filled, families), { kind: "font", text: "", fontFamily: "Material Symbols", source: "" });
    assert.deepEqual(resolveIconSpec("image:/home/me/start.svg", false, regular, filled, families), { kind: "image", text: "", fontFamily: "", source: "/home/me/start.svg" });
    assert.equal(resolveIconSpec("font:Broken:zz", false, regular, filled, families), EMPTY_ICON);
});
