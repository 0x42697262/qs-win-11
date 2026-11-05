import { test } from "node:test";
import assert from "node:assert/strict";
import { airplaneModeActive, batteryIcon, batteryStatusText, fillCommandTemplate, networkIcon, sortNetworks, toPercent, toggleTileVisibility, volumeIcon } from "../../src/domain/system/indicators.mjs";
import { Icon } from "../../src/domain/catalog/icons.mjs";

test("volume, battery and network icons follow levels", () => {
    assert.equal(volumeIcon(0.5, true), Icon.speakerMute);
    assert.equal(volumeIcon(0, false), Icon.speakerMute);
    assert.equal(volumeIcon(1, false), Icon.speaker2);
    assert.equal(batteryIcon(0.5, true), Icon.batteryCharge);
    assert.equal(batteryIcon(1, false), Icon.battery10);
    assert.equal(batteryIcon(0, false), Icon.battery0);
    assert.equal(networkIcon(true, true, 0, false), Icon.plugConnected);
    assert.equal(networkIcon(false, false, 1, true), Icon.wifiOff);
    assert.equal(networkIcon(true, false, 1, true), Icon.wifi1);
});

test("battery text shows charging or time remaining", () => {
    const text = { charging: "charging", remaining: "remaining" };
    assert.equal(batteryStatusText(0.42, true, 0, text), "42% · charging");
    assert.equal(batteryStatusText(0.42, false, 5400, text), "42% · 1 h 30 min remaining");
    assert.equal(toPercent(1.4), 100);
});

test("networks sort connected, known, then signal", () => {
    const networks = [
        { name: "weak", connected: false, known: false, signalStrength: 0.2 },
        { name: "home", connected: true, known: true, signalStrength: 0.5 },
        { name: "", connected: false, known: false, signalStrength: 1 },
        { name: "strong", connected: false, known: false, signalStrength: 0.9 },
        { name: "office", connected: false, known: true, signalStrength: 0.1 },
    ];
    assert.deepEqual(sortNetworks(networks, 3).map((network) => network.name), ["home", "office", "strong"]);
});

test("small helpers", () => {
    assert.ok(airplaneModeActive(false, false));
    assert.ok(!airplaneModeActive(true, false));
    assert.equal(fillCommandTemplate("brightnessctl set {percent}%", "{percent}", 40), "brightnessctl set 40%");
    assert.deepEqual(toggleTileVisibility(["wifi", "bluetooth"], "wifi"), ["bluetooth"]);
    assert.deepEqual(toggleTileVisibility(["bluetooth"], "wifi"), ["bluetooth", "wifi"]);
});
