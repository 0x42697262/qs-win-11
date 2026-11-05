import { test } from "node:test";
import assert from "node:assert/strict";
import { TIME_TEXT } from "./defaults.mjs";
import { groupByApp, idsBeyondLimit, relativeTime, toastDurationMs, Urgency } from "../../src/domain/notifications/notifications.mjs";
import { addMonths, daysInMonth, monthGrid, weekdayHeaders } from "../../src/domain/time/calendar.mjs";

test("toast duration honors app timeout, default and critical", () => {
    assert.equal(toastDurationMs(-1, Urgency.Normal, 5), 5000);
    assert.equal(toastDurationMs(3, Urgency.Normal, 5), 3000);
    assert.equal(toastDurationMs(0, Urgency.Normal, 5), 0);
    assert.equal(toastDurationMs(-1, Urgency.Critical, 5), 0);
});

test("grouping orders apps by newest notification", () => {
    const groups = groupByApp([
        { id: 1, appName: "Mail", receivedAtMs: 10 },
        { id: 2, appName: "Chat", receivedAtMs: 30 },
        { id: 3, appName: "Mail", receivedAtMs: 20 },
    ]);
    assert.deepEqual(groups.map((group) => [group.appName, group.ids]), [["Chat", [2]], ["Mail", [3, 1]]]);
});

test("history limit drops the oldest", () => {
    const entries = [1, 2, 3, 4].map((id) => ({ id, appName: "x", receivedAtMs: id }));
    assert.deepEqual(idsBeyondLimit(entries, 2), [2, 1]);
});

test("relative time text", () => {
    const text = { now: "Now", minutesAgo: "{count}m ago", hoursAgo: "{count}h ago", daysAgo: "{count}d ago" };
    assert.equal(relativeTime(60000, 30000, text), "Now");
    assert.equal(relativeTime(600000, 0, text), "10m ago");
    assert.equal(relativeTime(7200000, 0, text), "2h ago");
    assert.equal(relativeTime(172800000, 0, text), "2d ago");
});

test("calendar grid has six weeks and respects the first weekday", () => {
    const sundayFirst = monthGrid(2026, 10, "sunday");
    assert.equal(sundayFirst.length, 42);
    assert.deepEqual(sundayFirst[0], { year: 2026, month: 10, day: 1, inMonth: true });
    const mondayFirst = monthGrid(2026, 10, "monday");
    assert.deepEqual(mondayFirst[0], { year: 2026, month: 9, day: 26, inMonth: false });
    assert.equal(daysInMonth(2024, 1), 29);
    assert.deepEqual(addMonths(2026, 0, -1), { year: 2025, month: 11 });
    assert.deepEqual(weekdayHeaders("monday", TIME_TEXT.weekdayInitials).slice(0, 2), ["Mo", "Tu"]);
});
