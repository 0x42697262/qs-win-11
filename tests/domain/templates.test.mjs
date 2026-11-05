import { test } from "node:test";
import assert from "node:assert/strict";
import { buildTemplateScheme, flattenOver, formatValue, renderTemplate } from "../../src/domain/theming/templates.mjs";
import { buildPalette } from "../../src/domain/theme/palette.mjs";
import { DARK_BASE, LIGHT_BASE, ACCENT_SHADES } from "../../src/domain/catalog/tokens.mjs";
import { toQtColor } from "../../src/domain/theme/color.mjs";

/** @param {Record<string, { hex: string, alpha: number }>} base */
const colorsOf = (base) => Object.fromEntries(Object.entries(base).map(([key, token]) => [key, toQtColor(token)]));

const palette = buildPalette("dark", "#0078d4", true, { dark: colorsOf(DARK_BASE), light: colorsOf(LIGHT_BASE), accentMixLight: "#ffffff", accentMixDark: "#000000" }, ACCENT_SHADES);

test("translucent colors flatten over the background", () => {
    assert.equal(flattenOver("#80ffffff", "#000000"), "#808080");
    assert.equal(flattenOver("#ABCDEF", "#000000"), "#abcdef");
});

test("scheme has opaque hex colors for every name", () => {
    const scheme = buildTemplateScheme(palette, 0.35);
    assert.equal(scheme.background, "#202020");
    assert.equal(scheme.foreground, "#ffffff");
    assert.equal(scheme.red, "#f1707b");
    Object.values(scheme).forEach(color => assert.match(color, /^#[0-9a-f]{6}$/));
});

test("formats", () => {
    assert.equal(formatValue("#0a141e", "strip"), "0a141e");
    assert.equal(formatValue("#0a141e", "rgb"), "10, 20, 30");
    assert.equal(formatValue("#0a141e", "rgbCss"), "rgb(10, 20, 30)");
    assert.equal(formatValue("#ffffff", "float"), "1.0000 1.0000 1.0000");
    assert.equal(formatValue("#0a141e", "nope"), null);
});

test("templates render known names and report unknown ones", () => {
    const result = renderTemplate("bg={{ background.strip }} fg={{foreground}} mode={{ mode }} bad={{ nope.hex }} {{ red.wat }}", { background: "#202020", foreground: "#ffffff", red: "#ff0000" }, { mode: "dark" });
    assert.equal(result.text, "bg=202020 fg=#ffffff mode=dark bad={{ nope.hex }} {{ red.wat }}");
    assert.deepEqual(result.unknown, ["{{ nope.hex }}", "{{ red.wat }}"]);
});

test("render jobs prefer user templates and add custom ones", async () => {
    const { planRenderJobs } = await import("../../src/domain/theming/targets.mjs");
    const jobs = planRenderJobs(["kitty", "foot"], "/shell/assets/app-themes", ["/u/t/kitty.conf.tmpl", "/u/t/mako.conf.tmpl", "/u/t/readme.md"], "/u/t", "/u/out");
    assert.deepEqual(jobs, [
        { id: "foot", templatePath: "/shell/assets/app-themes/foot.ini.tmpl", outputPath: "/u/out/foot/colors.ini" },
        { id: "kitty", templatePath: "/u/t/kitty.conf.tmpl", outputPath: "/u/out/kitty/colors.conf" },
        { id: "mako.conf", templatePath: "/u/t/mako.conf.tmpl", outputPath: "/u/out/custom/mako.conf" },
    ]);
});

test("every bundled template renders without unknown placeholders", async () => {
    const { readFileSync } = await import("node:fs");
    const { APP_THEME_TARGETS, TEMPLATE_DIRECTORY, TEMPLATE_EXTENSION } = await import("../../src/domain/catalog/appThemes.mjs");
    const scheme = buildTemplateScheme(palette, 0.35);
    APP_THEME_TARGETS.forEach(target => {
        const template = readFileSync(new URL(`../../${TEMPLATE_DIRECTORY}/${target.template}${TEMPLATE_EXTENSION}`, import.meta.url), "utf8");
        const result = renderTemplate(template, scheme, { mode: "dark" });
        assert.deepEqual(result.unknown, [], target.id);
        if (target.template.endsWith(".json")) {
            JSON.parse(result.text);
        }
    });
});
