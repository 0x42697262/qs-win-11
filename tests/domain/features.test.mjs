import { test } from "node:test";
import assert from "node:assert/strict";
import { resolveFeatures, FeatureOffReason } from "../../src/domain/features/resolveFeatures.mjs";
import { BusName, Capability, FEATURE_DEFAULTS } from "../../src/domain/catalog/features.mjs";

const allCapabilities = new Set(Object.values(Capability));

test("defaults with every capability enable all default-on features", () => {
    const result = resolveFeatures(FEATURE_DEFAULTS, allCapabilities, new Set());
    assert.equal(result.enabled.taskbar, true);
    assert.equal(result.enabled.lockScreen, false);
    assert.equal(result.offReasons.lockScreen?.reason, FeatureOffReason.DisabledByUser);
});

test("missing capability turns a feature off with a reason", () => {
    const capabilities = new Set([...allCapabilities].filter((capability) => capability !== Capability.NightLightCommand));
    const result = resolveFeatures(FEATURE_DEFAULTS, capabilities, new Set());
    assert.equal(result.enabled.nightLight, false);
    assert.deepEqual(result.offReasons.nightLight, { reason: FeatureOffReason.MissingCapability, detail: Capability.NightLightCommand });
});

test("a bus name owned by another process disables the feature", () => {
    const result = resolveFeatures(FEATURE_DEFAULTS, allCapabilities, new Set([BusName.Notifications]));
    assert.equal(result.enabled.notifications, false);
    assert.equal(result.offReasons.notifications?.reason, FeatureOffReason.BusNameTaken);
});

test("dependencies propagate", () => {
    const result = resolveFeatures({ ...FEATURE_DEFAULTS, widgets: false }, allCapabilities, new Set());
    assert.equal(result.enabled.weather, false);
    assert.equal(result.offReasons.weather?.reason, FeatureOffReason.DependencyOff);
});
