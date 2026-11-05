import { test } from "node:test";
import assert from "node:assert/strict";
import { buildTaskbarItems, taskbarClick, TaskbarClickAction } from "../../src/domain/apps/taskbarItems.mjs";
import { movePinnedApp, pinApp, unpinApp, isPinned, normalizeAppId } from "../../src/domain/apps/appIds.mjs";
import { makeWindowInfo } from "../../src/domain/compositor/windows.mjs";
import { toggleSurface, CLOSED, Surface } from "../../src/domain/shell/surfaces.mjs";
import { formatClockTime, formatShortDate, formatLongDate, formatDuration } from "../../src/domain/time/format.mjs";

const identity = (/** @type {string} */ appId) => appId;

test("pinned apps come first, running unpinned apps follow, windows group by app", () => {
    const windows = [
        makeWindowInfo({ id: "w1", appId: "kitty", active: true }),
        makeWindowInfo({ id: "w2", appId: "Firefox" }),
        makeWindowInfo({ id: "w3", appId: "kitty" }),
    ];
    const items = buildTaskbarItems(["firefox.desktop", "org.gnome.Nautilus"], windows, identity);
    assert.deepEqual(items.map((item) => [item.key, item.pinned, item.windowIds.length, item.active]), [
        ["firefox", true, 1, false],
        ["org.gnome.nautilus", true, 0, false],
        ["kitty", false, 2, true],
    ]);
});

test("taskbar clicks launch, focus, cycle or minimize", () => {
    const base = { appId: "kitty", key: "kitty", pinned: true, active: false, urgent: false, title: "" };
    assert.equal(taskbarClick({ ...base, windowIds: [] }, "", true).action, TaskbarClickAction.Launch);
    assert.deepEqual(taskbarClick({ ...base, windowIds: ["w1"] }, "other", true), { action: TaskbarClickAction.Focus, windowId: "w1" });
    assert.deepEqual(taskbarClick({ ...base, windowIds: ["w1", "w2"] }, "w1", true), { action: TaskbarClickAction.CycleNext, windowId: "w2" });
    assert.equal(taskbarClick({ ...base, windowIds: ["w1"] }, "w1", true).action, TaskbarClickAction.Minimize);
    assert.equal(taskbarClick({ ...base, windowIds: ["w1"] }, "w1", false).action, TaskbarClickAction.Focus);
});

test("pinning is case and suffix insensitive and keeps order", () => {
    assert.equal(normalizeAppId(" Firefox.desktop "), "firefox");
    assert.deepEqual(pinApp(["firefox"], "Firefox.desktop"), ["firefox"]);
    assert.deepEqual(unpinApp(["firefox", "kitty"], "FIREFOX"), ["kitty"]);
    assert.ok(isPinned(["kitty"], "Kitty"));
    assert.deepEqual(movePinnedApp(["alpha", "beta", "gamma"], "gamma", 0), ["gamma", "alpha", "beta"]);
});

test("toggling the same surface on the same screen closes it", () => {
    const opened = toggleSurface(CLOSED, Surface.StartMenu, "DP-1", null);
    assert.equal(opened.surface, Surface.StartMenu);
    assert.equal(toggleSurface(opened, Surface.StartMenu, "DP-1", null).surface, Surface.None);
    assert.equal(toggleSurface(opened, Surface.QuickSettings, "DP-1", null).surface, Surface.QuickSettings);
    assert.equal(toggleSurface(opened, Surface.StartMenu, "HDMI-A-1", null).screenName, "HDMI-A-1");
});

test("clock and date formatting", () => {
    assert.equal(formatClockTime({ hours: 0, minutes: 5, seconds: 9 }, false, false), "12:05 AM");
    assert.equal(formatClockTime({ hours: 13, minutes: 5, seconds: 9 }, false, true), "1:05:09 PM");
    assert.equal(formatClockTime({ hours: 13, minutes: 5, seconds: 9 }, true, false), "13:05");
    assert.equal(formatShortDate({ year: 2026, month: 10, day: 5, weekday: 4 }), "11/5/2026");
    assert.equal(formatLongDate({ year: 2026, month: 10, day: 5, weekday: 4 }), "Thursday, November 5");
    assert.equal(formatDuration(135), "2 h 15 min");
});

import { shortWeekdayFromIso } from "../../src/domain/time/format.mjs";

test("short weekday from an ISO date", () => {
    assert.equal(shortWeekdayFromIso("2026-11-05"), "Thu");
});
