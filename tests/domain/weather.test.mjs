import { test } from "node:test";
import assert from "node:assert/strict";
import { buildForecastUrl, describeWeather, formatTemperature, nextLocationSource, parseForecast, parseGeoclueOutput, parseIpLookup, LocationSource } from "../../src/domain/weather/weather.mjs";
import { cpuUsage, memoryUsage, parseCpuSample } from "../../src/domain/system/stats.mjs";
import { Icon } from "../../src/domain/catalog/icons.mjs";

test("forecast url carries location and unit", () => {
    const url = buildForecastUrl({ latitude: 14.6, longitude: 121, placeName: "" }, "fahrenheit");
    assert.ok(url.startsWith("https://api.open-meteo.com/v1/forecast?latitude=14.6&longitude=121"));
    assert.ok(url.includes("temperature_unit=fahrenheit"));
});

test("forecast parses current and daily values", () => {
    const forecast = parseForecast({
        current: { temperature_2m: 31.4, weather_code: 2 },
        daily: { time: ["2026-11-05", "2026-11-06"], weather_code: [2, 61], temperature_2m_max: [33, 30], temperature_2m_min: [25, 24] },
    });
    assert.equal(forecast?.temperature, 31.4);
    assert.equal(forecast?.high, 33);
    assert.equal(forecast?.days.length, 2);
    assert.equal(parseForecast({}), null);
    assert.equal(describeWeather(61).icon, Icon.weatherRain);
    assert.equal(describeWeather(1234).text, "Unknown");
    assert.equal(formatTemperature(31.6), "32°");
});

test("location parsers", () => {
    assert.deepEqual(parseIpLookup({ success: true, latitude: 1.5, longitude: 2.5, city: "Davao" }), { latitude: 1.5, longitude: 2.5, placeName: "Davao" });
    assert.equal(parseIpLookup({ success: false }), null);
    assert.deepEqual(parseGeoclueOutput("New location:\nLatitude:    7.0731°\nLongitude:   125.6128°\nAccuracy: 30 meters"), { latitude: 7.0731, longitude: 125.6128, placeName: "" });
    assert.equal(parseGeoclueOutput("nothing"), null);
});

test("location source order: manual, fresh cache, geoclue, ip lookup, stale cache", () => {
    const auto = { locationMode: "auto", allowIpLookup: true };
    assert.equal(nextLocationSource({ locationMode: "manual", allowIpLookup: true }, { fetchedAtMs: 0 }, 0, 10, true, []), LocationSource.Manual);
    assert.equal(nextLocationSource(auto, { fetchedAtMs: 95 }, 100, 10, true, []), LocationSource.Cache);
    assert.equal(nextLocationSource(auto, { fetchedAtMs: 0 }, 100, 10, true, []), LocationSource.Geoclue);
    assert.equal(nextLocationSource(auto, { fetchedAtMs: 0 }, 100, 10, true, ["geoclue"]), LocationSource.IpLookup);
    assert.equal(nextLocationSource({ locationMode: "auto", allowIpLookup: false }, { fetchedAtMs: 0 }, 100, 10, false, []), LocationSource.None);
    assert.equal(nextLocationSource({ locationMode: "auto", allowIpLookup: false }, { fetchedAtMs: 1 }, 100, 10, false, []), LocationSource.Cache);
});

test("cpu and memory usage", () => {
    const first = parseCpuSample("cpu  100 0 100 700 100 0 0 0 0 0\ncpu0 1 2 3");
    const second = parseCpuSample("cpu  250 0 250 750 150 0 0 0 0 0");
    assert.deepEqual(first, { idle: 800, total: 1000 });
    assert.equal(cpuUsage(first, second), 0.75);
    assert.equal(memoryUsage("MemTotal:  1000 kB\nMemFree: 100 kB\nMemAvailable:  250 kB\n"), 0.75);
});
