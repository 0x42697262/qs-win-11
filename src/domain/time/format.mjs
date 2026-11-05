import { MINUTES_PER_HOUR } from "../catalog/tuning.mjs";

const HOURS_PER_HALF_DAY = 12;
const TWO_DIGITS = 2;
const MORNING_SUFFIX = "AM";
const EVENING_SUFFIX = "PM";
const MONTH_NAMES = Object.freeze(["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]);
const WEEKDAY_NAMES = Object.freeze(["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]);

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
 * @returns {string}
 */
export function formatClockTime(time, use24Hour, showSeconds) {
    const seconds = showSeconds ? `:${twoDigits(time.seconds)}` : "";
    if (use24Hour) {
        return `${twoDigits(time.hours)}:${twoDigits(time.minutes)}${seconds}`;
    }
    const hour = time.hours % HOURS_PER_HALF_DAY === 0 ? HOURS_PER_HALF_DAY : time.hours % HOURS_PER_HALF_DAY;
    const suffix = time.hours < HOURS_PER_HALF_DAY ? MORNING_SUFFIX : EVENING_SUFFIX;
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
 * @returns {string}
 */
export function formatLongDate(date) {
    return `${WEEKDAY_NAMES[date.weekday] ?? ""}, ${MONTH_NAMES[date.month] ?? ""} ${date.day}`;
}

/**
 * @param {number} year
 * @param {number} month
 * @returns {string}
 */
export function formatMonthYear(year, month) {
    return `${MONTH_NAMES[month] ?? ""} ${year}`;
}

/**
 * @param {number} totalMinutes
 * @returns {string}
 */
export function formatDuration(totalMinutes) {
    const hours = Math.floor(totalMinutes / MINUTES_PER_HOUR);
    const minutes = Math.round(totalMinutes % MINUTES_PER_HOUR);
    return hours > 0 ? `${hours} h ${minutes} min` : `${minutes} min`;
}

export { WEEKDAY_NAMES, MONTH_NAMES };
