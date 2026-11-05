import { test } from "node:test";
import assert from "node:assert/strict";
import { activeLevel, KnobSource, resolveAppearance } from "../../src/domain/appearance/resolveAppearance.mjs";
import { LEVEL_BUNDLES } from "../../src/domain/catalog/appearance.mjs";

/** @param {Partial<import("../../src/domain/appearance/resolveAppearance.mjs").AppearanceSettings>} changes */
function settings(changes) {
    return Object.assign({ style: "fluent", level: 3, levelOnBattery: -1, override: {}, levels: LEVEL_BUNDLES }, changes);
}

test("level bundle supplies values", () => {
    const appearance = resolveAppearance(settings({}), false);
    assert.equal(appearance.levelName, "rich");
    assert.deepEqual(appearance.knobs.backdrop, { value: "mica", source: KnobSource.Level, requested: "mica" });
});

test("flat style changes look within the budget", () => {
    const appearance = resolveAppearance(settings({ style: "flat" }), false);
    assert.equal(appearance.knobs.backdrop?.value, "tint");
    assert.equal(appearance.knobs.corners?.source, KnobSource.Style);
});

test("custom overrides win inside the budget and are limited above it", () => {
    const cheaper = resolveAppearance(settings({ override: { animations: "fades" } }), false);
    assert.deepEqual(cheaper.knobs.animations, { value: "fades", source: KnobSource.Custom, requested: "fades" });
    const pricier = resolveAppearance(settings({ level: 0, override: { backdrop: "mica" } }), false);
    assert.deepEqual(pricier.knobs.backdrop, { value: "solid", source: KnobSource.Limited, requested: "mica" });
});

test("battery level applies only on battery", () => {
    assert.equal(activeLevel(settings({ levelOnBattery: 1 }), false), 3);
    assert.equal(activeLevel(settings({ levelOnBattery: 1 }), true), 1);
    assert.equal(activeLevel(settings({ levelOnBattery: -1 }), true), 3);
});

test("edited level bundles are honored", () => {
    const levels = Object.assign({}, LEVEL_BUNDLES, { rich: Object.assign({}, LEVEL_BUNDLES.rich, { grain: "off" }) });
    assert.equal(resolveAppearance(settings({ levels }), false).knobs.grain?.value, "off");
});
