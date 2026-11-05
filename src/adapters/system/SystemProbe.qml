import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.services
import "../../domain/system/probe.mjs" as Probe
import "../../domain/catalog/logEvents.mjs" as LogEvents
import "../../domain/catalog/tuning.mjs" as Tuning
import "../../domain/catalog/system.mjs" as SystemCatalog

Scope {
    id: root

    required property list<string> binaries
    required property list<string> busNames
    required property list<string> systemBusNames

    property var result: Probe.parseProbeOutput("")
    readonly property int ownProcessId: Probe.processIdFromStat(selfStat.text())
    readonly property list<string> busNamesTakenByOthers: ownProcessId > 0 ? Probe.busNamesTakenByOthers(result.busOwners, ownProcessId) : []
    property bool finished: false

    function run(): void {
        process.running = false;
        process.command = Probe.buildProbeCommand(binaries, busNames, systemBusNames);
        process.running = true;
        timeout.restart();
    }

    Component.onCompleted: run()

    FileView {
        id: selfStat
        path: SystemCatalog.SystemPath.OwnProcessStat
        blockLoading: true
    }

    Process {
        id: process
        stdout: StdioCollector {
            onStreamFinished: {
                timeout.stop();
                root.result = Probe.parseProbeOutput(text);
                root.finished = true;
                Log.info(LogEvents.LogEvent.CapabilityProbed, {
                    binaries: [...root.result.binaries],
                    busNamesTaken: root.busNamesTakenByOthers,
                    backlights: root.result.backlights,
                });
            }
        }
    }

    Timer {
        id: timeout
        interval: Tuning.CAPABILITY_PROBE_TIMEOUT_MS
        onTriggered: {
            process.running = false;
            root.finished = true;
            Log.warning(LogEvents.LogEvent.ProcessTimedOut, { command: SystemCatalog.SystemBinary.Shell });
        }
    }
}
