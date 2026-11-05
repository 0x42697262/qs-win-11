import { test } from "node:test";
import assert from "node:assert/strict";
import { extractAccent, hslToHex, rgbToHsl } from "../../src/domain/theme/accentFromImage.mjs";

const OPTIONS = { hueBuckets: 24, minSaturation: 0.25, minValue: 0.2, lightnessMin: 0.35, lightnessMax: 0.6, saturationMin: 0.45 };

/** @param {number[][]} colors @param {number[]} counts */
function image(colors, counts) {
    /** @type {number[]} */
    const pixels = [];
    colors.forEach((color, index) => {
        for (let repeat = 0; repeat < counts[index]; repeat += 1) {
            pixels.push(color[0], color[1], color[2], color.length > 3 ? color[3] : 255);
        }
    });
    return pixels;
}

test("hsl round trips", () => {
    const blue = rgbToHsl(0, 120, 212);
    assert.equal(hslToHex(blue), "#0078d4");
    assert.deepEqual(rgbToHsl(128, 128, 128).saturation, 0);
});

test("the dominant vivid hue wins over grays", () => {
    const pixels = image([[128, 128, 128], [20, 120, 220], [220, 40, 40]], [500, 60, 20]);
    const accent = extractAccent(pixels, OPTIONS) ?? "";
    const hue = rgbToHsl(parseInt(accent.slice(1, 3), 16), parseInt(accent.slice(3, 5), 16), parseInt(accent.slice(5, 7), 16)).hue;
    assert.ok(hue > 200 && hue < 220, `${accent} hue ${hue}`);
});

test("lightness is clamped into the usable range", () => {
    const accent = extractAccent(image([[255, 230, 230]], [10]), Object.assign({}, OPTIONS, { minSaturation: 0 })) ?? "";
    assert.ok(rgbToHsl(parseInt(accent.slice(1, 3), 16), parseInt(accent.slice(3, 5), 16), parseInt(accent.slice(5, 7), 16)).lightness <= 0.61);
});

test("gray or transparent images give no accent", () => {
    assert.equal(extractAccent(image([[100, 100, 100]], [50]), OPTIONS), null);
    assert.equal(extractAccent(image([[255, 0, 0, 0]], [50]), OPTIONS), null);
});

test("wallpaper listing", async () => {
    const { parseWallpaperList, wallpaperFindCommand, wallpaperName } = await import("../../src/domain/wallpaper/gallery.mjs");
    const { expandHome } = await import("../../src/domain/system/paths.mjs");
    assert.equal(expandHome("~/Pictures/Wallpapers", "/home/ada"), "/home/ada/Pictures/Wallpapers");
    assert.equal(wallpaperName("/a/b/Sunset.Beach.jpg"), "Sunset.Beach");
    assert.deepEqual(parseWallpaperList("/w/zeta.png\n\n/w/alpha.jpg\n/w/mid.webp\n", 2), [{ path: "/w/alpha.jpg", name: "alpha" }, { path: "/w/mid.webp", name: "mid" }]);
    const command = wallpaperFindCommand("/w", 2);
    assert.deepEqual(command.slice(0, 5), ["find", "-L", "/w", "-maxdepth", "2"]);
    assert.ok(command.includes("*.jpg"));
});

test("ImageMagick txt output parses into RGBA", async () => {
    const { parseMagickPixels, magickSampleCommand } = await import("../../src/domain/theme/accentFromImage.mjs");
    const output = "# ImageMagick pixel enumeration: 2,1,0,255,srgba\n0,0: (10,20,30,255)  #0A141EFF  srgba(10,20,30,1)\n1,0: (1,2,3)  #010203  srgb(1,2,3)\n";
    assert.deepEqual(parseMagickPixels(output), [10, 20, 30, 255, 1, 2, 3, 255]);
    assert.deepEqual(magickSampleCommand("magick", "/w.jpg", 48).slice(-4), ["48x48!", "-depth", "8", "txt:-"]);
});
