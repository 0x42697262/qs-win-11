pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import "../../../domain/notifications/notifications.mjs" as NotificationRules
import "../../../domain/catalog/compositor.mjs" as CompositorCatalog
import "../../../domain/shell/surfaces.mjs" as Surfaces

PanelWindow {
    id: root

    readonly property list<Notification> shown: Notifications.toasts.slice(0, Settings.values.tuning.toastStackLimit)

    screen: Quickshell.screens.find(candidate => candidate.name === ShellState.defaultScreenName()) ?? Quickshell.screens[0]
    visible: shown.length > 0 && ShellState.openSurface !== Surfaces.Surface.NotificationCenter
    anchors.bottom: true
    anchors.right: true
    implicitWidth: Theme.size.toastWidth + Theme.spacing.medium * 2
    implicitHeight: stack.implicitHeight + Theme.spacing.medium * 2
    exclusionMode: ExclusionMode.Normal
    color: Theme.colors.transparent
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: CompositorCatalog.LayerNamespace.Toast

    ColumnLayout {
        id: stack
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Theme.spacing.medium
        spacing: Theme.size.toastStackSpacing

        Repeater {
            model: root.shown

            NotificationCard {
                id: toast

                required property Notification modelData
                readonly property int durationMs: NotificationRules.toastDurationMs(notification.expireTimeout, notification.urgency, Settings.values.notifications.toastSeconds)

                Layout.fillWidth: true
                notification: modelData
                showTime: false
                opacity: 0
                offset: Theme.elevation.toastSlide * Theme.scale

                Component.onCompleted: toastEntrance.start()

                ParallelAnimation {
                    id: toastEntrance
                    NumberAnimation { target: toast; property: "opacity"; to: 1; duration: Theme.motion.normal; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
                    NumberAnimation { target: toast; property: "offset"; to: 0; duration: Theme.motion.toastEnter; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.emphasized }
                }
                onCloseRequested: Notifications.hideToast(modelData.id)

                Timer {
                    interval: toast.durationMs
                    running: toast.durationMs > 0 && !toast.hovered
                    onTriggered: toast.dismiss()
                }
            }
        }
    }
}
