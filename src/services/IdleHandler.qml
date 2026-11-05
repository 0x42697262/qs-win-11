pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.src.config
import "../domain/power/idleStages.mjs" as IdleRules
import "../domain/catalog/logEvents.mjs" as LogEvents

Scope {
    id: root

    property bool dimmed: false
    readonly property list<var> steps: IdleRules.idleSteps(Settings.values.idle)

    function enter(stage: string): void {
        Log.info(LogEvents.LogEvent.IdleStage, { stage, entered: true });
        if (stage === IdleRules.IdleStage.Dim) {
            dimmed = true;
        } else if (stage === IdleRules.IdleStage.Lock) {
            Session.lock();
        } else if (stage === IdleRules.IdleStage.ScreenOff) {
            Session.runCommandLine(Settings.values.commands.screenOff);
        } else if (stage === IdleRules.IdleStage.Suspend) {
            Session.suspend();
        }
    }

    function leave(stage: string): void {
        if (stage === IdleRules.IdleStage.Dim) {
            dimmed = false;
        } else if (stage === IdleRules.IdleStage.ScreenOff) {
            Session.runCommandLine(Settings.values.commands.screenOn);
        }
    }

    Instantiator {
        model: root.steps

        IdleMonitor {
            required property var modelData
            timeout: modelData.seconds
            enabled: !StayAwake.active
            respectInhibitors: true
            onIsIdleChanged: isIdle ? root.enter(modelData.stage) : root.leave(modelData.stage)
        }
    }

    Variants {
        model: root.dimmed ? Quickshell.screens : []

        DimLayer {}
    }
}
