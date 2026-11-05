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
    readonly property string requested: ShellState.openScreenName === modelData.name && surfaceComponents[ShellState.openSurface] !== undefined ? ShellState.openSurface : Surfaces.Surface.None
    readonly property bool open: requested !== Surfaces.Surface.None
    property string shownSurface: Surfaces.Surface.None
    readonly property bool leaving: exit.running

    function present(): void {
        exit.stop();
        if (requested !== Surfaces.Surface.None) {
            shownSurface = requested;
            entrance.restart();
        } else if (shownSurface !== Surfaces.Surface.None) {
            entrance.stop();
            exit.restart();
        }
    }

    onRequestedChanged: present()

    screen: modelData
    visible: shownSurface !== Surfaces.Surface.None
    color: Theme.colors.transparent
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    exclusionMode: ExclusionMode.Normal
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: CompositorCatalog.LayerNamespace.Flyout
    WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    mask: Region { item: root.open ? fullArea : null }

    Item {
        id: fullArea
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.open
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
            active: root.shownSurface !== Surfaces.Surface.None
            sourceComponent: root.surfaceComponents[root.shownSurface] ?? null
            onLoaded: (item as Item)?.forceActiveFocus()
        }
    }

    ParallelAnimation {
        id: entrance
        NumberAnimation { target: stage; property: "opacity"; from: 0; to: 1; duration: Theme.motion.normal; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
        NumberAnimation { target: slide; property: "y"; from: Theme.slideDistance; to: 0; duration: Theme.motion.enter; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.emphasized }
        NumberAnimation { target: grow; property: "xScale"; from: Appearance.richMotion ? Theme.elevation.richScaleFrom : 1; to: 1; duration: Theme.motion.enter; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.emphasized }
        NumberAnimation { target: grow; property: "yScale"; from: Appearance.richMotion ? Theme.elevation.richScaleFrom : 1; to: 1; duration: Theme.motion.enter; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.emphasized }
    }

    SequentialAnimation {
        id: exit
        ParallelAnimation {
            NumberAnimation { target: stage; property: "opacity"; to: 0; duration: Theme.motion.exit; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.exitCurve }
            NumberAnimation { target: slide; property: "y"; to: Theme.slideDistance * Theme.elevation.exitSlideFraction; duration: Theme.motion.exit; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.exitCurve }
        }
        ScriptAction { script: root.shownSurface = Surfaces.Surface.None }
    }
}
