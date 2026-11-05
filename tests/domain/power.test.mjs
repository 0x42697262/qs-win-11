import { test } from "node:test";
import assert from "node:assert/strict";
import { BatteryAlertLevel, batteryAlertLevel, nextBatteryAlert } from "../../src/domain/power/batteryAlerts.mjs";
import { idleSteps } from "../../src/domain/power/idleStages.mjs";

test("alert level follows thresholds and charging", () => {
    assert.equal(batteryAlertLevel(50, false, 15, 5), BatteryAlertLevel.None);
    assert.equal(batteryAlertLevel(12, false, 15, 5), BatteryAlertLevel.Low);
    assert.equal(batteryAlertLevel(4, false, 15, 5), BatteryAlertLevel.Critical);
    assert.equal(batteryAlertLevel(4, true, 15, 5), BatteryAlertLevel.None);
});

test("alerts fire once per level and reset after hysteresis or charging", () => {
    let state = nextBatteryAlert(BatteryAlertLevel.None, 14, false, 15, 5, 2);
    assert.equal(state.alertNow, BatteryAlertLevel.Low);
    state = nextBatteryAlert(state.alertedLevel, 13, false, 15, 5, 2);
    assert.equal(state.alertNow, BatteryAlertLevel.None);
    state = nextBatteryAlert(state.alertedLevel, 16, false, 15, 5, 2);
    assert.equal(state.alertNow, BatteryAlertLevel.None);
    assert.equal(state.alertedLevel, BatteryAlertLevel.Low);
    state = nextBatteryAlert(state.alertedLevel, 5, false, 15, 5, 2);
    assert.equal(state.alertNow, BatteryAlertLevel.Critical);
    state = nextBatteryAlert(state.alertedLevel, 5, true, 15, 5, 2);
    assert.equal(state.alertedLevel, BatteryAlertLevel.None);
});

test("idle steps skip zero and sort by time", () => {
    assert.deepEqual(idleSteps({ dimSeconds: 300, lockSeconds: 0, screenOffSeconds: 60, suspendSeconds: 900 }).map((step) => step.stage), ["screenOff", "dim", "suspend"]);
});
