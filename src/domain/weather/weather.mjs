import { TemperatureUnit, LocationMode } from "../catalog/enums.mjs";
import { FORECAST_DAYS, UNKNOWN_WEATHER, WEATHER_CODE_GROUPS, WeatherEndpoint } from "../catalog/weatherCodes.mjs";

const OPEN_METEO_FAHRENHEIT = "fahrenheit";
const OPEN_METEO_CELSIUS = "celsius";
const COORDINATE_PATTERN = /(Latitude|Longitude):\s*(-?\d+(?:\.\d+)?)/g;
const DEGREE_SIGN = "°";

/** @typedef {{ latitude: number, longitude: number, placeName: string }} Location */
/** @typedef {{ dateIso: string, code: number, high: number, low: number }} ForecastDay */
/** @typedef {{ temperature: number, code: number, high: number, low: number, days: ForecastDay[] }} Forecast */

/**
 * @param {Location} location
 * @param {string} unit
 * @returns {string}
 */
export function buildForecastUrl(location, unit) {
    const temperatureUnit = unit === TemperatureUnit.Fahrenheit ? OPEN_METEO_FAHRENHEIT : OPEN_METEO_CELSIUS;
    const query = [
        `latitude=${location.latitude}`,
        `longitude=${location.longitude}`,
        "current=temperature_2m,weather_code",
        "daily=weather_code,temperature_2m_max,temperature_2m_min",
        `temperature_unit=${temperatureUnit}`,
        "timezone=auto",
        `forecast_days=${FORECAST_DAYS}`,
    ].join("&");
    return `${WeatherEndpoint.forecast}?${query}`;
}

/**
 * @param {unknown} payload
 * @returns {Forecast | null}
 */
export function parseForecast(payload) {
    const data = /** @type {{ current?: { temperature_2m?: number, weather_code?: number }, daily?: { time?: string[], weather_code?: number[], temperature_2m_max?: number[], temperature_2m_min?: number[] } }} */ (payload);
    const current = data && data.current;
    const daily = data && data.daily;
    if (!current || typeof current.temperature_2m !== "number" || !daily || !Array.isArray(daily.time)) {
        return null;
    }
    const days = daily.time.map((dateIso, index) => ({
        dateIso,
        code: (daily.weather_code ?? [])[index] ?? -1,
        high: (daily.temperature_2m_max ?? [])[index] ?? 0,
        low: (daily.temperature_2m_min ?? [])[index] ?? 0,
    }));
    const today = days[0];
    return {
        temperature: current.temperature_2m,
        code: current.weather_code ?? -1,
        high: today ? today.high : current.temperature_2m,
        low: today ? today.low : current.temperature_2m,
        days,
    };
}

/**
 * @param {number} code
 * @returns {{ icon: import("../catalog/icons.mjs").Glyph, text: string }}
 */
export function describeWeather(code) {
    const group = WEATHER_CODE_GROUPS.find((candidate) => candidate.codes.includes(code)) ?? UNKNOWN_WEATHER;
    return { icon: group.icon, text: group.text };
}

/**
 * @param {number} value
 * @returns {string}
 */
export function formatTemperature(value) {
    return `${Math.round(value)}${DEGREE_SIGN}`;
}

/**
 * @param {unknown} payload
 * @returns {Location | null}
 */
export function parseIpLookup(payload) {
    const data = /** @type {{ success?: boolean, latitude?: number, longitude?: number, city?: string }} */ (payload);
    if (!data || data.success === false || typeof data.latitude !== "number" || typeof data.longitude !== "number") {
        return null;
    }
    return { latitude: data.latitude, longitude: data.longitude, placeName: data.city ?? "" };
}

/**
 * @param {string} output
 * @returns {Location | null}
 */
export function parseGeoclueOutput(output) {
    /** @type {Record<string, number>} */
    const values = {};
    let match = COORDINATE_PATTERN.exec(output);
    while (match) {
        values[match[1] ?? ""] = Number(match[2]);
        match = COORDINATE_PATTERN.exec(output);
    }
    COORDINATE_PATTERN.lastIndex = 0;
    const latitude = values.Latitude;
    const longitude = values.Longitude;
    return latitude === undefined || longitude === undefined ? null : { latitude, longitude, placeName: "" };
}

export const LocationSource = Object.freeze({ Manual: "manual", Cache: "cache", Geoclue: "geoclue", IpLookup: "ipLookup", None: "none" });

/**
 * @param {{ locationMode: string, allowIpLookup: boolean }} weatherSettings
 * @param {{ fetchedAtMs: number }} cache
 * @param {number} nowMs
 * @param {number} cacheLifetimeMs
 * @param {boolean} geoclueAvailable
 * @param {readonly string[]} failedSources
 * @returns {string}
 */
export function nextLocationSource(weatherSettings, cache, nowMs, cacheLifetimeMs, geoclueAvailable, failedSources) {
    if (weatherSettings.locationMode === LocationMode.Manual) {
        return LocationSource.Manual;
    }
    if (cache.fetchedAtMs > 0 && nowMs - cache.fetchedAtMs < cacheLifetimeMs) {
        return LocationSource.Cache;
    }
    if (geoclueAvailable && !failedSources.includes(LocationSource.Geoclue)) {
        return LocationSource.Geoclue;
    }
    if (weatherSettings.allowIpLookup && !failedSources.includes(LocationSource.IpLookup)) {
        return LocationSource.IpLookup;
    }
    return cache.fetchedAtMs > 0 ? LocationSource.Cache : LocationSource.None;
}
