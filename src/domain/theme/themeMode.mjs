import { ResolvedThemeMode, ThemeMode } from "../catalog/enums.mjs";
import { MINUTES_PER_HOUR } from "../catalog/tuning.mjs";

const TIME_SEPARATOR = ":";

/**
 * @param {string} clockTime
 * @returns {number}
 */
export function minutesOfDay(clockTime) {
    const [hours, minutes] = clockTime.split(TIME_SEPARATOR).map(Number);
    return (hours ?? 0) * MINUTES_PER_HOUR + (minutes ?? 0);
}

/**
 * @param {string} mode
 * @param {number} nowMinutes
 * @param {string} lightStartsAt
 * @param {string} darkStartsAt
 * @returns {typeof ResolvedThemeMode[keyof typeof ResolvedThemeMode]}
 */
export function resolveThemeMode(mode, nowMinutes, lightStartsAt, darkStartsAt) {
    if (mode === ThemeMode.Light) {
        return ResolvedThemeMode.Light;
    }
    if (mode === ThemeMode.Dark) {
        return ResolvedThemeMode.Dark;
    }
    const lightStart = minutesOfDay(lightStartsAt);
    const darkStart = minutesOfDay(darkStartsAt);
    const isLight = lightStart <= darkStart
        ? nowMinutes >= lightStart && nowMinutes < darkStart
        : nowMinutes >= lightStart || nowMinutes < darkStart;
    return isLight ? ResolvedThemeMode.Light : ResolvedThemeMode.Dark;
}
