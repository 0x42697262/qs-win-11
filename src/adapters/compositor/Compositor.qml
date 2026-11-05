pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import qs.src.services
import "../../domain/compositor/selection.mjs" as Selection
import "../../domain/catalog/enums.mjs" as Enums
import "../../domain/catalog/logEvents.mjs" as LogEvents

Singleton {
    id: root

    readonly property string kind: Selection.selectCompositorKind(Settings.values.compositor.kind, Environment.hyprlandSignature)
    readonly property CompositorAdapter adapter: (hyprland.item ?? generic.item) as CompositorAdapter

    onKindChanged: Log.info(LogEvents.LogEvent.CompositorSelected, { kind: root.kind })
    Component.onCompleted: Log.info(LogEvents.LogEvent.CompositorSelected, { kind: root.kind })

    LazyLoader {
        id: hyprland
        active: root.kind === Enums.CompositorKind.Hyprland
        HyprlandAdapter {}
    }

    LazyLoader {
        id: generic
        active: root.kind === Enums.CompositorKind.Generic
        WlrToplevelAdapter {}
    }
}
