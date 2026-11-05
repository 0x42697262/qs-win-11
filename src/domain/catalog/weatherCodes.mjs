import { Icon } from "./icons.mjs";

/** @typedef {{ codes: readonly number[], icon: string, textKey: string }} WeatherCodeGroup */

/** @type {readonly WeatherCodeGroup[]} */
export const WEATHER_CODE_GROUPS = Object.freeze([
    { codes: [0], icon: Icon.weatherSunny, textKey: "clear" },
    { codes: [1, 2], icon: Icon.weatherPartlyCloudyDay, textKey: "partlyCloudy" },
    { codes: [3], icon: Icon.weatherCloudy, textKey: "cloudy" },
    { codes: [45, 48], icon: Icon.weatherFog, textKey: "fog" },
    { codes: [51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82], icon: Icon.weatherRain, textKey: "rain" },
    { codes: [71, 73, 75, 77, 85, 86], icon: Icon.weatherSnow, textKey: "snow" },
    { codes: [95, 96, 99], icon: Icon.weatherThunderstorm, textKey: "thunderstorms" },
]);

export const UNKNOWN_WEATHER = Object.freeze({ codes: [], icon: Icon.weatherCloudy, textKey: "unknown" });

export const WeatherEndpoint = Object.freeze({
    forecast: "https://api.open-meteo.com/v1/forecast",
    ipLookup: "https://ipwho.is/",
    geoclueDemo: "/usr/lib/geoclue-2.0/demos/where-am-i",
});

export const FORECAST_DAYS = 5;
