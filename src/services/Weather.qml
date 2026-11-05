pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import qs.src.adapters.http
import "../domain/weather/weather.mjs" as WeatherRules
import "../domain/catalog/logEvents.mjs" as LogEvents
import "../domain/catalog/tuning.mjs" as Tuning

Singleton {
    id: root

    property var forecast: null
    property bool failed: false
    readonly property bool available: forecast !== null
    readonly property var location: Location.location
    readonly property string unit: Settings.values.weather.unit
    readonly property var current: forecast ? WeatherRules.describeWeather(forecast.code) : null
    readonly property string temperatureText: forecast ? WeatherRules.formatTemperature(forecast.temperature) : ""

    function refresh(): void {
        if (!Features.enabled.weather || location === null) {
            return;
        }
        Http.getJson(WeatherRules.buildForecastUrl(location, unit), Tuning.WEATHER_REQUEST_TIMEOUT_MS, (error, data) => {
            const parsed = error === "" ? WeatherRules.parseForecast(data) : null;
            root.failed = parsed === null;
            if (parsed) {
                root.forecast = parsed;
                Log.info(LogEvents.LogEvent.WeatherUpdated, { temperature: parsed.temperature, code: parsed.code });
            }
        });
    }

    onLocationChanged: debounce.restart()
    onUnitChanged: debounce.restart()

    Timer {
        id: debounce
        interval: Tuning.WEATHER_DEBOUNCE_MS
        onTriggered: root.refresh()
    }

    Timer {
        running: Features.enabled.weather
        repeat: true
        interval: Tuning.WEATHER_REFRESH_MS
        onTriggered: root.refresh()
    }
}
