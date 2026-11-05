import { test } from "node:test";
import assert from "node:assert/strict";
import { busNamesTakenByOthers, commandBinary, parseProbeOutput, processIdFromStat } from "../../src/domain/system/probe.mjs";

test("probe output parses binaries, bus owners and backlights", () => {
    const result = parseProbeOutput("bin\tnotify-send\nbus\torg.freedesktop.Notifications\t42\nsysbus\tnet.hadess.PowerProfiles\nbacklight\t/sys/class/backlight/intel\n\n");
    assert.ok(result.binaries.has("notify-send"));
    assert.equal(result.busOwners.get("org.freedesktop.Notifications"), 42);
    assert.deepEqual(result.backlights, ["/sys/class/backlight/intel"]);
    assert.ok(result.systemBusNames.has("net.hadess.PowerProfiles"));
});

test("bus names owned by this process are not conflicts", () => {
    const owners = new Map([["a.b", 10], ["c.d", 11]]);
    assert.deepEqual(busNamesTakenByOthers(owners, 10), ["c.d"]);
});

test("helpers extract pid and command binary", () => {
    assert.equal(processIdFromStat("1234 (qs) S 1"), 1234);
    assert.equal(commandBinary("  hyprsunset -t 4000"), "hyprsunset");
});
