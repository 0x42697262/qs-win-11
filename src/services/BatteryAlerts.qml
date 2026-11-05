import QtQuick
import Quickshell
import qs.src.config
import "../domain/power/batteryAlerts.mjs" as AlertRules
import "../domain/catalog/strings.mjs" as Strings
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/enums.mjs" as Enums
import "../domain/catalog/logEvents.mjs" as LogEvents

Scope {
    id: root

    property int alertedLevel: AlertRules.BatteryAlertLevel.None
    readonly property var powerSettings: Settings.values.power

    function evaluate(): void {
        const next = AlertRules.nextBatteryAlert(alertedLevel, Power.percent, Power.charging, powerSettings.lowBatteryPercent, powerSettings.criticalBatteryPercent, Settings.values.tuning.batteryAlertHysteresisPercent);
        alertedLevel = next.alertedLevel;
        if (next.alertNow === AlertRules.BatteryAlertLevel.None) {
            return;
        }
        const critical = next.alertNow === AlertRules.BatteryAlertLevel.Critical;
        const text = Settings.values.text.power;
        const body = (critical ? text.batteryCriticalBody : text.batteryLowBody).split(Strings.COUNT_PLACEHOLDER).join(String(Power.percent));
        Log.warning(LogEvents.LogEvent.BatteryAlert, { percent: Power.percent, level: next.alertNow });
        Quickshell.execDetached([SystemCatalog.SystemBinary.NotifySend, "-a", text.appName, "-u", critical ? SystemCatalog.NotifyUrgency.Critical : SystemCatalog.NotifyUrgency.Normal, critical ? text.batteryCriticalTitle : text.batteryLowTitle, body]);
        if (critical) {
            runCriticalAction();
        }
    }

    function runCriticalAction(): void {
        const action = powerSettings.criticalAction;
        if (action === Enums.CriticalBatteryAction.Suspend) {
            Session.suspend();
        } else if (action === Enums.CriticalBatteryAction.Hibernate) {
            Session.hibernate();
        } else if (action === Enums.CriticalBatteryAction.PowerOff) {
            Session.powerOff();
        }
    }

    Connections {
        target: Power
        function onPercentChanged(): void {
            root.evaluate();
        }
        function onChargingChanged(): void {
            root.evaluate();
        }
    }

    Component.onCompleted: evaluate()
}
