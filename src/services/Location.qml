pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import qs.src.adapters.http
import "../domain/weather/weather.mjs" as WeatherRules
import "../domain/catalog/weatherCodes.mjs" as WeatherCatalog
import "../domain/catalog/shellDataSchema.mjs" as ShellDataSchema
import "../domain/catalog/logEvents.mjs" as LogEvents
import "../domain/catalog/tuning.mjs" as Tuning

Singleton {
    id: root

    readonly property var weatherSettings: Settings.values.weather
    readonly property var cached: ShellData.values.location
    property list<string> failedSources: []
    property bool resolving: false
    property bool geoclueAvailable: geoclueCheck.loaded
    readonly property string source: WeatherRules.nextLocationSource(weatherSettings, cached, Clock.nowMs, Tuning.LOCATION_CACHE_MS, geoclueAvailable, failedSources)
    readonly property var location: {
        if (source === WeatherRules.LocationSource.Manual) {
            return { latitude: weatherSettings.manualLatitude, longitude: weatherSettings.manualLongitude, placeName: weatherSettings.manualPlaceName };
        }
        if (source === WeatherRules.LocationSource.Cache) {
            return { latitude: cached.latitude, longitude: cached.longitude, placeName: cached.placeName };
        }
        return null;
    }

    onSourceChanged: resolve()
    Component.onCompleted: resolve()

    function store(found: var): void {
        ShellData.update(ShellDataSchema.ShellDataKey.LocationLatitude, found.latitude);
        ShellData.update(ShellDataSchema.ShellDataKey.LocationLongitude, found.longitude);
        ShellData.update(ShellDataSchema.ShellDataKey.LocationPlaceName, found.placeName);
        ShellData.update(ShellDataSchema.ShellDataKey.LocationFetchedAtMs, Math.round(Date.now()));
        Log.info(LogEvents.LogEvent.LocationResolved, { source });
    }

    function fail(failedSource: string): void {
        Log.info(LogEvents.LogEvent.LocationFailed, { source: failedSource });
        failedSources = failedSources.concat([failedSource]);
    }

    function resolve(): void {
        if (!Features.enabled.weather || resolving) {
            return;
        }
        if (source === WeatherRules.LocationSource.Geoclue) {
            resolving = true;
            geoclue.running = true;
        } else if (source === WeatherRules.LocationSource.IpLookup) {
            resolving = true;
            Http.getJson(WeatherCatalog.WeatherEndpoint.ipLookup, Tuning.WEATHER_REQUEST_TIMEOUT_MS, (error, data) => {
                resolving = false;
                const found = error === "" ? WeatherRules.parseIpLookup(data) : null;
                if (found) {
                    store(found);
                } else {
                    fail(WeatherRules.LocationSource.IpLookup);
                }
            });
        }
    }

    FileView {
        id: geoclueCheck
        path: WeatherCatalog.WeatherEndpoint.geoclueDemo
        printErrors: false
        preload: true
    }

    Process {
        id: geoclue
        command: [WeatherCatalog.WeatherEndpoint.geoclueDemo, "-t", String(Tuning.GEOCLUE_TIMEOUT_SECONDS)]
        stdout: StdioCollector {
            onStreamFinished: {
                root.resolving = false;
                const found = WeatherRules.parseGeoclueOutput(text);
                if (found) {
                    root.store(found);
                } else {
                    root.fail(WeatherRules.LocationSource.Geoclue);
                }
            }
        }
    }
}
