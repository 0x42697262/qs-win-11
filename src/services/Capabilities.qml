pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower
import qs.src.config
import qs.src.adapters.system
import qs.src.adapters.compositor
import "../domain/catalog/features.mjs" as FeatureCatalog
import "../domain/system/probe.mjs" as Probe
import "../domain/catalog/system.mjs" as SystemCatalog

Singleton {
    id: root

    readonly property string nightLightBinary: Probe.commandBinary(Settings.values.commands.nightLight)
    readonly property list<string> compositorCapabilities: Compositor.adapter ? Compositor.adapter.capabilities : []
    readonly property list<string> backlights: probe.result.backlights
    readonly property bool hasPowerProfiles: has(FeatureCatalog.Capability.PowerProfiles)
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
        if (Object.values(SystemCatalog.SystemBusName).some(name => probe.result.systemBusNames.has(name))) {
            found.add(FeatureCatalog.Capability.PowerProfiles);
        }
        if (binaries.has(SystemCatalog.SystemBinary.Nmcli)) {
            found.add(FeatureCatalog.Capability.NetworkManagerCli);
        }
        if (binaries.has(SystemCatalog.SystemBinary.Ddcutil)) {
            found.add(FeatureCatalog.Capability.DisplayControl);
        }
        if (binaries.has(SystemCatalog.SystemBinary.Magick) || binaries.has(SystemCatalog.SystemBinary.Convert)) {
            found.add(FeatureCatalog.Capability.ImageSampling);
        }
        if (binaries.has(SystemCatalog.SystemBinary.Cava)) {
            found.add(FeatureCatalog.Capability.AudioVisualizer);
        }
        if (binaries.has(SystemCatalog.SystemBinary.Grim)) {
            found.add(FeatureCatalog.Capability.ScreenCapture);
        }
        if (binaries.has(SystemCatalog.SystemBinary.GpuScreenRecorder) || binaries.has(SystemCatalog.SystemBinary.WfRecorder)) {
            found.add(FeatureCatalog.Capability.Recorder);
        }
        if (UPower.displayDevice.isLaptopBattery) {
            found.add(FeatureCatalog.Capability.Battery);
        }
        return found;
    }
    readonly property string imageSamplingBinary: probe.result.binaries.has(SystemCatalog.SystemBinary.Magick) ? SystemCatalog.SystemBinary.Magick : SystemCatalog.SystemBinary.Convert
    readonly property var takenBusNames: new Set(probe.busNamesTakenByOthers)

    function hasBinary(name: string): bool {
        return probe.result.binaries.has(name);
    }

    function has(capability: string): bool {
        return available.has(capability);
    }

    SystemProbe {
        id: probe
        binaries: [SystemCatalog.SystemBinary.NotifySend, SystemCatalog.SystemBinary.Gsettings, SystemCatalog.SystemBinary.Nmcli, SystemCatalog.SystemBinary.Ddcutil, SystemCatalog.SystemBinary.Magick, SystemCatalog.SystemBinary.Convert, SystemCatalog.SystemBinary.Cava, SystemCatalog.SystemBinary.Grim, SystemCatalog.SystemBinary.WlCopy, SystemCatalog.SystemBinary.GpuScreenRecorder, SystemCatalog.SystemBinary.WfRecorder, root.nightLightBinary, Probe.commandBinary(Settings.values.commands.brightness)]
        busNames: Object.values(FeatureCatalog.BusName)
        systemBusNames: Object.values(SystemCatalog.SystemBusName)
    }
}
