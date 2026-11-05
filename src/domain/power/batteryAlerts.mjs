export const BatteryAlertLevel = Object.freeze({ None: 0, Low: 1, Critical: 2 });

/**
 * @param {number} percent
 * @param {boolean} charging
 * @param {number} lowPercent
 * @param {number} criticalPercent
 * @returns {number}
 */
export function batteryAlertLevel(percent, charging, lowPercent, criticalPercent) {
    if (charging) {
        return BatteryAlertLevel.None;
    }
    if (percent <= criticalPercent) {
        return BatteryAlertLevel.Critical;
    }
    return percent <= lowPercent ? BatteryAlertLevel.Low : BatteryAlertLevel.None;
}

/**
 * @param {number} alertedLevel
 * @param {number} percent
 * @param {boolean} charging
 * @param {number} lowPercent
 * @param {number} criticalPercent
 * @param {number} hysteresisPercent
 * @returns {{ alertedLevel: number, alertNow: number }}
 */
export function nextBatteryAlert(alertedLevel, percent, charging, lowPercent, criticalPercent, hysteresisPercent) {
    const level = batteryAlertLevel(percent, charging, lowPercent, criticalPercent);
    if (charging || percent > lowPercent + hysteresisPercent) {
        return { alertedLevel: BatteryAlertLevel.None, alertNow: BatteryAlertLevel.None };
    }
    if (level > alertedLevel) {
        return { alertedLevel: level, alertNow: level };
    }
    return { alertedLevel, alertNow: BatteryAlertLevel.None };
}
