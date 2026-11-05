import { MILLISECONDS_PER_SECOND, SECONDS_PER_MINUTE, MINUTES_PER_HOUR } from "../catalog/tuning.mjs";
import { COUNT_PLACEHOLDER } from "../catalog/strings.mjs";

export const Urgency = Object.freeze({ Low: 0, Normal: 1, Critical: 2 });
const APP_TIMEOUT_DEFAULT = -1;
const HOURS_PER_DAY = 24;

/** @typedef {{ id: number, appName: string, receivedAtMs: number }} NotificationEntry */
/** @typedef {{ appName: string, ids: number[], newestMs: number }} NotificationGroup */
/** @typedef {{ now: string, minutesAgo: string, hoursAgo: string, daysAgo: string }} RelativeTimeText */

/**
 * @param {number} expireTimeoutSeconds
 * @param {number} urgency
 * @param {number} defaultSeconds
 * @returns {number}
 */
export function toastDurationMs(expireTimeoutSeconds, urgency, defaultSeconds) {
    if (urgency === Urgency.Critical || expireTimeoutSeconds === 0) {
        return 0;
    }
    const seconds = expireTimeoutSeconds > 0 && expireTimeoutSeconds !== APP_TIMEOUT_DEFAULT ? expireTimeoutSeconds : defaultSeconds;
    return seconds * MILLISECONDS_PER_SECOND;
}

/**
 * @param {readonly NotificationEntry[]} entries
 * @returns {NotificationGroup[]}
 */
export function groupByApp(entries) {
    /** @type {Map<string, NotificationGroup>} */
    const groups = new Map();
    entries.slice().sort((left, right) => right.receivedAtMs - left.receivedAtMs).forEach((entry) => {
        const group = groups.get(entry.appName);
        if (group) {
            group.ids.push(entry.id);
        } else {
            groups.set(entry.appName, { appName: entry.appName, ids: [entry.id], newestMs: entry.receivedAtMs });
        }
    });
    return Array.from(groups.values());
}

/**
 * @param {readonly NotificationEntry[]} entries
 * @param {number} limit
 * @returns {number[]}
 */
export function idsBeyondLimit(entries, limit) {
    const newestFirst = entries.slice().sort((left, right) => right.receivedAtMs - left.receivedAtMs);
    return newestFirst.slice(limit).map((entry) => entry.id);
}

/**
 * @param {number} nowMs
 * @param {number} thenMs
 * @param {RelativeTimeText} text
 * @returns {string}
 */
export function relativeTime(nowMs, thenMs, text) {
    const minutes = Math.floor((nowMs - thenMs) / (MILLISECONDS_PER_SECOND * SECONDS_PER_MINUTE));
    if (minutes < 1) {
        return text.now;
    }
    if (minutes < MINUTES_PER_HOUR) {
        return text.minutesAgo.split(COUNT_PLACEHOLDER).join(String(minutes));
    }
    const hours = Math.floor(minutes / MINUTES_PER_HOUR);
    if (hours < HOURS_PER_DAY) {
        return text.hoursAgo.split(COUNT_PLACEHOLDER).join(String(hours));
    }
    return text.daysAgo.split(COUNT_PLACEHOLDER).join(String(Math.floor(hours / HOURS_PER_DAY)));
}
