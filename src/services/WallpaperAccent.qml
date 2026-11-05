pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/theme/accentFromImage.mjs" as AccentRules
import "../domain/catalog/shellDataSchema.mjs" as ShellDataSchema
import "../domain/catalog/features.mjs" as FeatureCatalog
import "../domain/catalog/logEvents.mjs" as LogEvents

Singleton {
    id: root

    readonly property bool wanted: Settings.values.theme.accentFromWallpaper
    readonly property string path: Settings.values.wallpaper.path
    readonly property string accent: ShellData.values.wallpaperAccent.color
    readonly property bool active: wanted && accent !== "" && ShellData.values.wallpaperAccent.source === path
    readonly property bool canSample: Capabilities.has(FeatureCatalog.Capability.ImageSampling)
    readonly property bool needsSample: wanted && canSample && path !== "" && ShellData.values.wallpaperAccent.source !== path

    function sample(): void {
        if (!needsSample || sampler.running) {
            return;
        }
        const tuning = Settings.values.tuning;
        sampler.sampledPath = path;
        sampler.command = AccentRules.magickSampleCommand(Capabilities.imageSamplingBinary, path, tuning.accentSampleSize);
        sampler.running = true;
    }

    onNeedsSampleChanged: sample()
    Component.onCompleted: sample()

    Process {
        id: sampler

        property string sampledPath: ""

        stdout: StdioCollector {
            onStreamFinished: {
                const tuning = Settings.values.tuning;
                const picked = AccentRules.extractAccent(AccentRules.parseMagickPixels(text), {
                    hueBuckets: tuning.accentHueBuckets,
                    minSaturation: tuning.accentMinSaturation,
                    minValue: tuning.accentMinValue,
                    saturationMin: tuning.accentSaturationMin,
                    lightnessMin: tuning.accentLightnessMin,
                    lightnessMax: tuning.accentLightnessMax,
                }) ?? "";
                ShellData.update(ShellDataSchema.ShellDataKey.WallpaperAccent, picked);
                ShellData.update(ShellDataSchema.ShellDataKey.WallpaperAccentSource, sampler.sampledPath);
                Log.info(LogEvents.LogEvent.WallpaperAccentPicked, { path: sampler.sampledPath, accent: picked });
            }
        }
    }
}
