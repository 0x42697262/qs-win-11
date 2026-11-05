pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower
import qs.src.config
import qs.src.adapters.system
import "../domain/catalog/features.mjs" as FeatureCatalog
import "../domain/system/probe.mjs" as Probe
import "../domain/catalog/system.mjs" as SystemCatalog

Singleton {
    id: root

    readonly property string nightLightBinary: Probe.commandBinary(Settings.values.commands.nightLight)
    readonly property list<string> compositorCapabilities: []
    readonly property list<string> backlights: probe.result.backlights
    readonly property bool probed: probe.finished
    readonly property var available: {
        const binaries = probe.result.binaries;
        const found = new Set(compositorCapabilities);
        if (binaries.has(nightLightBinary)) {
            found.add(FeatureCatalog.Capability.NightLightCommand);
        }
        if (binaries.has(SystemCatalog.SystemBinary.NotifySend)) {
            found.add(FeatureCatalog.Capability.NotifySend);
        }
        if (binaries.has(SystemCatalog.SystemBinary.Gsettings)) {
            found.add(FeatureCatalog.Capability.ColorSchemeSync);
        }
        if (probe.result.backlights.length > 0 && binaries.has(Probe.commandBinary(Settings.values.commands.brightness))) {
            found.add(FeatureCatalog.Capability.Backlight);
        }
        if (UPower.displayDevice.isLaptopBattery) {
            found.add(FeatureCatalog.Capability.Battery);
        }
        return found;
    }
    readonly property var takenBusNames: new Set(probe.busNamesTakenByOthers)

    function has(capability: string): bool {
        return available.has(capability);
    }

    SystemProbe {
        id: probe
        binaries: [SystemCatalog.SystemBinary.NotifySend, SystemCatalog.SystemBinary.Gsettings, root.nightLightBinary, Probe.commandBinary(Settings.values.commands.brightness)]
        busNames: Object.values(FeatureCatalog.BusName)
    }
}
