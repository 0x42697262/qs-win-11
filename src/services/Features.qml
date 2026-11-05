pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import "../domain/features/resolveFeatures.mjs" as FeatureRules
import "../domain/catalog/features.mjs" as FeatureCatalog
import "../domain/catalog/logEvents.mjs" as LogEvents

Singleton {
    readonly property var flags: {
        const featureSettings = Settings.values.features;
        const result = {};
        Object.values(FeatureCatalog.FeatureName).forEach(name => result[name] = featureSettings[name].enabled);
        return result;
    }
    readonly property var resolved: FeatureRules.resolveFeatures(flags, Capabilities.available, Capabilities.takenBusNames)
    readonly property var enabled: resolved.enabled
    readonly property var experimental: Settings.values.experimental

    onResolvedChanged: {
        if (!Capabilities.probed) {
            return;
        }
        Object.entries(resolved.offReasons)
            .filter(([, off]) => off.reason !== FeatureRules.FeatureOffReason.DisabledByUser)
            .forEach(([feature, off]) => Log.info(LogEvents.LogEvent.FeatureDisabled, { feature, reason: off.reason, detail: off.detail }));
    }
}
