import { MINUTES_PER_HOUR } from "../catalog/units.mjs";

const HOURS_PER_HALF_DAY = 12;
const TWO_DIGITS = 2;
const SHORT_WEEKDAY_LENGTH = 3;
/** @typedef {{ monthNames: readonly string[], weekdayNames: readonly string[], morning: string, evening: string, hoursShort: string, minutesShort: string }} TimeText */

/** @typedef {{ hours: number, minutes: number, seconds: number }} ClockTime */
/** @typedef {{ year: number, month: number, day: number, weekday: number }} CalendarDate */

/**
 * @param {number} value
 * @returns {string}
 */
function twoDigits(value) {
    return String(value).padStart(TWO_DIGITS, "0");
}

/**
 * @param {ClockTime} time
 * @param {boolean} use24Hour
 * @param {boolean} showSeconds
 * @param {TimeText} text
 * @returns {string}
 */
export function formatClockTime(time, use24Hour, showSeconds, text) {
    const seconds = showSeconds ? `:${twoDigits(time.seconds)}` : "";
    if (use24Hour) {
        return `${twoDigits(time.hours)}:${twoDigits(time.minutes)}${seconds}`;
    }
    const hour = time.hours % HOURS_PER_HALF_DAY === 0 ? HOURS_PER_HALF_DAY : time.hours % HOURS_PER_HALF_DAY;
    const suffix = time.hours < HOURS_PER_HALF_DAY ? text.morning : text.evening;
    return `${hour}:${twoDigits(time.minutes)}${seconds} ${suffix}`;
}

/**
 * @param {CalendarDate} date
 * @returns {string}
 */
export function formatShortDate(date) {
    return `${date.month + 1}/${date.day}/${date.year}`;
}

/**
 * @param {CalendarDate} date
 * @param {TimeText} text
 * @returns {string}
 */
export function formatLongDate(date, text) {
    return `${text.weekdayNames[date.weekday] ?? ""}, ${text.monthNames[date.month] ?? ""} ${date.day}`;
}

/**
 * @param {number} year
 * @param {number} month
 * @param {TimeText} text
 * @returns {string}
 */
export function formatMonthYear(year, month, text) {
    return `${text.monthNames[month] ?? ""} ${year}`;
}

/**
 * @param {number} totalMinutes
 * @param {TimeText} text
 * @returns {string}
 */
export function formatDuration(totalMinutes, text) {
    const hours = Math.floor(totalMinutes / MINUTES_PER_HOUR);
    const minutes = Math.round(totalMinutes % MINUTES_PER_HOUR);
    return hours > 0 ? `${hours} ${text.hoursShort} ${minutes} ${text.minutesShort}` : `${minutes} ${text.minutesShort}`;
}


/**
 * @param {string} dateIso
 * @param {TimeText} text
 * @returns {string}
 */
export function shortWeekdayFromIso(dateIso, text) {
    const parts = dateIso.split("-").map(Number);
    const date = new Date(parts[0] ?? 0, (parts[1] ?? 1) - 1, parts[2] ?? 1);
    return (text.weekdayNames[date.getDay()] ?? "").slice(0, SHORT_WEEKDAY_LENGTH);
}
