import { test } from "node:test";
import assert from "node:assert/strict";
import { buildIconIndex, classifyIconSpec, iconThemeDirectories, parseAppIconOverrides } from "../../src/domain/apps/appIcons.mjs";

test("overrides parse appId=spec with normalized ids", () => {
    assert.deepEqual(parseAppIconOverrides(["Firefox.desktop=/icons/fox.svg", "kitty = utilities-terminal", "broken"]), { firefox: "/icons/fox.svg", kitty: "utilities-terminal" });
});

test("specs classify into files or theme names", () => {
    assert.deepEqual(classifyIconSpec("/a/b.svg"), { isFile: true, value: "file:///a/b.svg" });
    assert.deepEqual(classifyIconSpec("image:/a/b.png"), { isFile: true, value: "file:///a/b.png" });
    assert.deepEqual(classifyIconSpec("https://x/y.png"), { isFile: true, value: "https://x/y.png" });
    assert.deepEqual(classifyIconSpec("firefox"), { isFile: false, value: "firefox" });
});

test("index prefers scalable, then the largest size", () => {
    const index = buildIconIndex([
        "/usr/share/icons/Papirus/16x16/apps/firefox.svg",
        "/usr/share/icons/Papirus/64x64/apps/firefox.svg",
        "/usr/share/icons/Papirus/48x48/apps/kitty.png",
        "/usr/share/icons/Papirus/scalable/apps/kitty.svg",
        "/usr/share/icons/Papirus/index.theme",
    ].join("\n"));
    assert.equal(index.firefox, "file:///usr/share/icons/Papirus/64x64/apps/firefox.svg");
    assert.equal(index.kitty, "file:///usr/share/icons/Papirus/scalable/apps/kitty.svg");
    assert.equal(Object.keys(index).length, 2);
});

test("theme directories follow XDG order", () => {
    assert.deepEqual(iconThemeDirectories("/h/.local/share", "/usr/local/share:/usr/share", "/h", "Papirus"), [
        "/h/.local/share/icons/Papirus", "/h/.icons/Papirus", "/usr/local/share/icons/Papirus", "/usr/share/icons/Papirus",
    ]);
});
