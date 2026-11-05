import { test } from "node:test";
import assert from "node:assert/strict";
import { mixHex, toQtColor } from "../../src/domain/theme/color.mjs";
import { resolveThemeMode, minutesOfDay } from "../../src/domain/theme/themeMode.mjs";
import { buildPalette } from "../../src/domain/theme/palette.mjs";

test("colors mix and format as #AARRGGBB", () => {
    assert.equal(mixHex("#000000", "#ffffff", 0.5), "#808080");
    assert.equal(toQtColor({ hex: "#123456", alpha: 1 }), "#ff123456");
    assert.equal(toQtColor({ hex: "#123456", alpha: 0 }), "#00123456");
});

test("auto mode follows the schedule, including overnight ranges", () => {
    assert.equal(minutesOfDay("07:30"), 450);
    assert.equal(resolveThemeMode("auto", minutesOfDay("12:00"), "07:00", "19:00"), "light");
    assert.equal(resolveThemeMode("auto", minutesOfDay("23:00"), "07:00", "19:00"), "dark");
    assert.equal(resolveThemeMode("auto", minutesOfDay("02:00"), "20:00", "06:00"), "light");
    assert.equal(resolveThemeMode("light", minutesOfDay("23:00"), "07:00", "19:00"), "light");
});

test("palettes differ between modes and transparency can be turned off", () => {
    const dark = buildPalette("dark", "#0078d4", true);
    const light = buildPalette("light", "#0078d4", true);
    assert.notEqual(dark.textPrimary, light.textPrimary);
    assert.equal(dark.textOnAccent, "#ff000000");
    assert.equal(light.textOnAccent, "#ffffffff");
    assert.ok(buildPalette("dark", "#0078d4", false).taskbarBackground.startsWith("#ff"));
});
