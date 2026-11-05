import { FirstDayOfWeek } from "../catalog/enums.mjs";
import { Strings } from "../catalog/strings.mjs";

export const DAYS_PER_WEEK = 7;
export const WEEKS_SHOWN = 6;
const MONTHS_PER_YEAR = 12;
const WEEKDAY_INITIALS = Strings.time.weekdayInitials;

/** @typedef {{ year: number, month: number, day: number, inMonth: boolean }} CalendarCell */

/**
 * @param {number} year
 * @param {number} month
 * @returns {number}
 */
export function daysInMonth(year, month) {
    return new Date(year, month + 1, 0).getDate();
}

/**
 * @param {number} year
 * @param {number} month
 * @param {number} delta
 * @returns {{ year: number, month: number }}
 */
export function addMonths(year, month, delta) {
    const total = year * MONTHS_PER_YEAR + month + delta;
    return { year: Math.floor(total / MONTHS_PER_YEAR), month: ((total % MONTHS_PER_YEAR) + MONTHS_PER_YEAR) % MONTHS_PER_YEAR };
}

/**
 * @param {string} firstDayOfWeek
 * @returns {number}
 */
function weekStartIndex(firstDayOfWeek) {
    return firstDayOfWeek === FirstDayOfWeek.Monday ? 1 : 0;
}

/**
 * @param {number} year
 * @param {number} month
 * @param {string} firstDayOfWeek
 * @returns {CalendarCell[]}
 */
export function monthGrid(year, month, firstDayOfWeek) {
    const startOffset = (new Date(year, month, 1).getDay() - weekStartIndex(firstDayOfWeek) + DAYS_PER_WEEK) % DAYS_PER_WEEK;
    const previous = addMonths(year, month, -1);
    const next = addMonths(year, month, 1);
    const previousDays = daysInMonth(previous.year, previous.month);
    const currentDays = daysInMonth(year, month);
    /** @type {CalendarCell[]} */
    const cells = [];
    for (let index = 0; index < DAYS_PER_WEEK * WEEKS_SHOWN; index += 1) {
        const dayNumber = index - startOffset + 1;
        if (dayNumber < 1) {
            cells.push({ year: previous.year, month: previous.month, day: previousDays + dayNumber, inMonth: false });
        } else if (dayNumber > currentDays) {
            cells.push({ year: next.year, month: next.month, day: dayNumber - currentDays, inMonth: false });
        } else {
            cells.push({ year, month, day: dayNumber, inMonth: true });
        }
    }
    return cells;
}

/**
 * @param {string} firstDayOfWeek
 * @returns {string[]}
 */
export function weekdayHeaders(firstDayOfWeek) {
    const start = weekStartIndex(firstDayOfWeek);
    return WEEKDAY_INITIALS.slice(start).concat(WEEKDAY_INITIALS.slice(0, start));
}
