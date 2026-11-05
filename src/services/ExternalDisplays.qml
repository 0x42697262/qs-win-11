pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/system/ddc.mjs" as DdcRules
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/logEvents.mjs" as LogEvents
import "../domain/catalog/units.mjs" as Units

Singleton {
    id: root

    property list<var> displays: []
    property var percents: ({})
    property var pending: ({})
    readonly property bool available: Features.enabled.externalBrightness && displays.length > 0

    function busCommand(bus: string, tail: var): list<string> {
        return [SystemCatalog.SystemBinary.Ddcutil, SystemCatalog.DdcCommand.busFlag, bus].concat(Array.prototype.slice.call(tail));
    }

    function detect(): void {
        if (!Features.enabled.externalBrightness) {
            return;
        }
        detector.running = false;
        detector.running = true;
    }

    function percentOf(bus: string): real {
        return percents[bus] ?? 0;
    }

    function setFraction(bus: string, fraction: real): void {
        const percent = Math.round(Math.max(0, Math.min(1, fraction)) * Units.PERCENT);
        const nextPercents = Object.assign({}, percents);
        nextPercents[bus] = percent;
        percents = nextPercents;
        const nextPending = Object.assign({}, pending);
        nextPending[bus] = percent;
        pending = nextPending;
        writer.restart();
    }

    function flush(): void {
        Object.keys(pending).forEach(bus => {
            Quickshell.execDetached(busCommand(bus, SystemCatalog.DdcCommand.setBrightness).concat([String(pending[bus])]));
            Log.info(LogEvents.LogEvent.DisplayBrightnessSet, { bus, percent: pending[bus] });
        });
        pending = {};
    }

    Component.onCompleted: detect()

    Connections {
        target: Features
        function onEnabledChanged(): void {
            if (root.displays.length === 0) {
                root.detect();
            }
        }
    }

    Process {
        id: detector
        command: Array.prototype.slice.call(SystemCatalog.DdcCommand.detect)
        stdout: StdioCollector {
            onStreamFinished: {
                root.displays = DdcRules.parseDdcDisplays(text);
                Log.info(LogEvents.LogEvent.DisplaysDetected, { count: root.displays.length });
            }
        }
    }

    Instantiator {
        model: root.displays

        Process {
            id: reader
            required property var modelData
            running: true
            command: root.busCommand(modelData.bus, SystemCatalog.DdcCommand.getBrightness)
            stdout: StdioCollector {
                onStreamFinished: {
                    const percent = DdcRules.parseVcpPercent(text);
                    if (percent !== null) {
                        const next = Object.assign({}, root.percents);
                        next[reader.modelData.bus] = percent;
                        root.percents = next;
                    }
                }
            }
        }
    }

    Timer {
        id: writer
        interval: Settings.values.tuning.displayBrightnessDelayMs
        onTriggered: root.flush()
    }
}
