import { Icon } from "./icons.mjs";

/** @typedef {import("./icons.mjs").Glyph} Glyph */
/** @typedef {{ codes: readonly number[], icon: Glyph, text: string }} WeatherCodeGroup */

/** @type {readonly WeatherCodeGroup[]} */
export const WEATHER_CODE_GROUPS = Object.freeze([
    { codes: [0], icon: Icon.weatherSunny, text: "Clear" },
    { codes: [1, 2], icon: Icon.weatherPartlyCloudyDay, text: "Partly cloudy" },
    { codes: [3], icon: Icon.weatherCloudy, text: "Cloudy" },
    { codes: [45, 48], icon: Icon.weatherFog, text: "Fog" },
    { codes: [51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82], icon: Icon.weatherRain, text: "Rain" },
    { codes: [71, 73, 75, 77, 85, 86], icon: Icon.weatherSnow, text: "Snow" },
    { codes: [95, 96, 99], icon: Icon.weatherThunderstorm, text: "Thunderstorms" },
]);

export const UNKNOWN_WEATHER = Object.freeze({ codes: [], icon: Icon.weatherCloudy, text: "Unknown" });

export const WeatherEndpoint = Object.freeze({
    forecast: "https://api.open-meteo.com/v1/forecast",
    ipLookup: "https://ipwho.is/",
    geoclueDemo: "/usr/lib/geoclue-2.0/demos/where-am-i",
});

export const FORECAST_DAYS = 5;
