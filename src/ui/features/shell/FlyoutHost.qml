import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.src.services
import qs.src.ui.theme
import "../../../domain/shell/surfaces.mjs" as Surfaces
import "../../../domain/catalog/compositor.mjs" as CompositorCatalog

PanelWindow {
    id: root

    required property ShellScreen modelData
    required property var surfaceComponents
    readonly property string surface: ShellState.openSurface
    readonly property bool shown: ShellState.openScreenName === modelData.name && surface !== Surfaces.Surface.None && surfaceComponents[surface] !== undefined

    screen: modelData
    visible: shown
    color: Theme.colors.transparent
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    exclusionMode: ExclusionMode.Normal
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: CompositorCatalog.LayerNamespace.Flyout
    WlrLayershell.keyboardFocus: shown ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    onSurfaceChanged: if (shown) entrance.restart()
    onShownChanged: if (shown) entrance.restart()

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onClicked: ShellState.close()
    }

    FocusScope {
        id: stage
        anchors.fill: parent
        focus: true
        opacity: 0
        Keys.onEscapePressed: ShellState.close()

        transform: [
            Translate { id: slide; y: 0 },
            Scale { id: grow; origin.x: stage.width / 2; origin.y: stage.height; xScale: 1; yScale: 1 }
        ]

        Loader {
            id: loader
            anchors.fill: parent
            focus: true
            active: root.shown
            sourceComponent: root.surfaceComponents[root.surface] ?? null
            onLoaded: (item as Item)?.forceActiveFocus()
        }
    }

    ParallelAnimation {
        id: entrance
        NumberAnimation { target: stage; property: "opacity"; from: 0; to: 1; duration: Theme.motion.normal }
        NumberAnimation { target: slide; property: "y"; from: Theme.slideDistance; to: 0; duration: Theme.motion.slow; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
        NumberAnimation { target: grow; property: "xScale"; from: Appearance.richMotion ? Theme.elevation.richScaleFrom : 1; to: 1; duration: Theme.motion.slow; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
        NumberAnimation { target: grow; property: "yScale"; from: Appearance.richMotion ? Theme.elevation.richScaleFrom : 1; to: 1; duration: Theme.motion.slow; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
    }
}
