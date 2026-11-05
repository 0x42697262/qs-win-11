import { test } from "node:test";
import assert from "node:assert/strict";
import { parseVpnConnections, splitTerseLine } from "../../src/domain/system/connections.mjs";
import { parseDdcDisplays, parseVcpPercent } from "../../src/domain/system/ddc.mjs";
import { abbreviateLayout, changedLockKey, layoutCountFromOption, layoutFromEvent, ledIsOn, mainKeyboard, parseLockLeds } from "../../src/domain/system/keyboard.mjs";

test("nmcli terse lines unescape colons", () => {
    assert.deepEqual(splitTerseLine("Office\\: VPN:abc:vpn:yes"), ["Office: VPN", "abc", "vpn", "yes"]);
});

test("only VPN and WireGuard connections are listed", () => {
    const output = "Home Wi-Fi:u1:802-11-wireless:yes\nWork:u2:vpn:no\nwg0:u3:wireguard:yes\n";
    assert.deepEqual(parseVpnConnections(output), [
        { name: "Work", uuid: "u2", active: false },
        { name: "wg0", uuid: "u3", active: true },
    ]);
});

test("ddcutil detect lists displays with buses", () => {
    const output = "Display 1\n   I2C bus:  /dev/i2c-4\n   Monitor:             DEL:DELL U2719D:ABC123\n\nInvalid display\n   I2C bus:  /dev/i2c-7\n\nDisplay 2\n   I2C bus:  /dev/i2c-9\n   Monitor:             GSM:LG HDR 4K:XYZ\n";
    assert.deepEqual(parseDdcDisplays(output), [{ bus: "4", model: "DELL U2719D" }, { bus: "9", model: "LG HDR 4K" }]);
});

test("VCP brightness converts to percent", () => {
    assert.equal(parseVcpPercent("VCP 10 C 40 80"), 50);
    assert.equal(parseVcpPercent("garbage"), null);
});

test("layouts abbreviate like Windows", () => {
    assert.deepEqual(abbreviateLayout("English (US)"), { language: "ENG", variant: "US" });
    assert.deepEqual(abbreviateLayout("German"), { language: "GER", variant: "" });
    assert.deepEqual(abbreviateLayout(""), { language: "", variant: "" });
    assert.equal(layoutFromEvent("at-translated-set-2-keyboard,English (US)"), "English (US)");
});

test("main keyboard comes from hyprctl devices", () => {
    const parsed = { keyboards: [{ name: "aux", active_keymap: "German", main: false }, { name: "kb", active_keymap: "English (US)", main: true, capsLock: true, numLock: false }] };
    assert.deepEqual(mainKeyboard(parsed), { name: "kb", layout: "English (US)", main: true, capsLock: true, numLock: false });
    assert.equal(mainKeyboard({}), null);
    assert.equal(ledIsOn("1\n"), true);
    assert.equal(ledIsOn("0"), false);
});

test("layout count and lock lights", () => {
    assert.equal(layoutCountFromOption({ option: "input:kb_layout", str: "us,de" }), 2);
    assert.equal(layoutCountFromOption(null), 0);
    const leds = parseLockLeds("capslock\t1\nnumlock\t0\ncapslock\t0\n");
    assert.deepEqual(leds, { capsLock: true, numLock: false });
    assert.equal(changedLockKey({ capsLock: false, numLock: false }, leds), "capsLock");
    assert.equal(changedLockKey(leds, { capsLock: true, numLock: true }), "numLock");
    assert.equal(changedLockKey(leds, leds), "");
});
