pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower
import "../domain/system/indicators.mjs" as Indicators
import "../domain/catalog/strings.mjs" as Strings

Singleton {
    readonly property UPowerDevice battery: UPower.displayDevice
    readonly property bool hasBattery: battery.isLaptopBattery
    readonly property real fraction: battery.percentage
    readonly property int percent: Indicators.toPercent(fraction)
    readonly property bool charging: battery.state === UPowerDeviceState.Charging || battery.state === UPowerDeviceState.FullyCharged || battery.state === UPowerDeviceState.PendingCharge
    readonly property bool onBattery: UPower.onBattery
    readonly property var icon: Indicators.batteryIcon(fraction, charging)
    readonly property string statusText: Indicators.batteryStatusText(fraction, charging, battery.timeToEmpty, Strings.Strings.quickSettings)
    readonly property bool powerProfilesAvailable: Capabilities.hasPowerProfiles
    readonly property bool energySaver: powerProfilesAvailable && PowerProfiles.profile === PowerProfile.PowerSaver
    readonly property int profile: PowerProfiles.profile
    readonly property bool hasPerformanceProfile: PowerProfiles.hasPerformanceProfile

    function setEnergySaver(enabled: bool): void {
        PowerProfiles.profile = enabled ? PowerProfile.PowerSaver : PowerProfile.Balanced;
    }

    function setProfile(value: int): void {
        PowerProfiles.profile = value;
    }
}
