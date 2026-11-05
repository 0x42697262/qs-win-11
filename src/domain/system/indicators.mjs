import { BATTERY_LEVEL_ICONS, VOLUME_LEVEL_ICONS, WIFI_STRENGTH_ICONS, Icon } from "../catalog/icons.mjs";
import { PERCENT, SECONDS_PER_MINUTE } from "../catalog/units.mjs";
import { formatDuration } from "../time/format.mjs";

/** @typedef {string} Glyph */

/**
 * @param {readonly Glyph[]} icons
 * @param {number} fraction
 * @returns {Glyph}
 */
function pickByFraction(icons, fraction) {
    const clamped = Math.min(Math.max(fraction, 0), 1);
    const index = Math.min(icons.length - 1, Math.round(clamped * (icons.length - 1)));
    return icons[index] ?? Icon.battery0;
}

/**
 * @param {number} volume
 * @param {boolean} muted
 * @returns {Glyph}
 */
export function volumeIcon(volume, muted) {
    if (muted || volume <= 0) {
        return Icon.speakerMute;
    }
    return pickByFraction(VOLUME_LEVEL_ICONS, volume);
}

/**
 * @param {number} fraction
 * @param {boolean} charging
 * @returns {Glyph}
 */
export function batteryIcon(fraction, charging) {
    return charging ? Icon.batteryCharge : pickByFraction(BATTERY_LEVEL_ICONS, fraction);
}

/**
 * @param {boolean} wifiEnabled
 * @param {boolean} wiredConnected
 * @param {number} strength
 * @param {boolean} connected
 * @returns {Glyph}
 */
export function networkIcon(wifiEnabled, wiredConnected, strength, connected) {
    if (wiredConnected) {
        return Icon.plugConnected;
    }
    if (!wifiEnabled || !connected) {
        return Icon.wifiOff;
    }
    return pickByFraction(WIFI_STRENGTH_ICONS, strength);
}

/**
 * @param {number} fraction
 * @returns {number}
 */
export function toPercent(fraction) {
    return Math.round(Math.min(Math.max(fraction, 0), 1) * PERCENT);
}

/**
 * @param {number} fraction
 * @param {boolean} charging
 * @param {number} secondsLeft
 * @param {{ charging: string, remaining: string }} text
 * @param {import("../time/format.mjs").TimeText} timeText
 * @returns {string}
 */
export function batteryStatusText(fraction, charging, secondsLeft, text, timeText) {
    const percent = `${toPercent(fraction)}%`;
    if (charging) {
        return `${percent} · ${text.charging}`;
    }
    return secondsLeft > 0 ? `${percent} · ${formatDuration(secondsLeft / SECONDS_PER_MINUTE, timeText)} ${text.remaining}` : percent;
}

/**
 * @template {{ connected: boolean, known: boolean, signalStrength: number, name: string }} NetworkLike
 * @param {readonly NetworkLike[]} networks
 * @param {number} limit
 * @returns {NetworkLike[]}
 */
export function sortNetworks(networks, limit) {
    const rank = (/** @type {NetworkLike} */ network) => (network.connected ? 2 : 0) + (network.known ? 1 : 0);
    return networks
        .filter((network) => network.name !== "")
        .slice()
        .sort((left, right) => rank(right) - rank(left) || right.signalStrength - left.signalStrength)
        .slice(0, limit);
}

/**
 * @param {boolean} wifiEnabled
 * @param {boolean} bluetoothEnabled
 * @returns {boolean}
 */
export function airplaneModeActive(wifiEnabled, bluetoothEnabled) {
    return !wifiEnabled && !bluetoothEnabled;
}

/**
 * @param {string} template
 * @param {string} placeholder
 * @param {number} percent
 * @returns {string}
 */
export function fillCommandTemplate(template, placeholder, percent) {
    return template.split(placeholder).join(String(percent));
}

/**
 * @param {readonly string[]} tiles
 * @param {string} tile
 * @returns {string[]}
 */
export function toggleTileVisibility(tiles, tile) {
    return tiles.includes(tile) ? tiles.filter((candidate) => candidate !== tile) : tiles.concat([tile]);
}
