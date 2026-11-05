import QtQuick
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components

Interactive {
    id: root

    property var icon: null
    property bool iconFilled: false
    property color iconColor: Theme.colors.textPrimary
    property string iconSource: ""
    property string appId: ""
    property string toolTip: ""
    property bool running: false
    property bool active: false
    property bool urgent: false
    property bool checked: false
    property list<string> previewWindowIds: []

    implicitWidth: Theme.size.taskbarButton
    implicitHeight: Theme.size.taskbarButton

    SmoothRectangle {
        anchors.fill: parent
        radius: Theme.radius.control
        smoothingOverride: Theme.controlSmoothing
        color: root.pressed ? Theme.colors.subtleFillPressed : (root.hovered || root.active || root.checked) ? Theme.colors.subtleFillHover : Theme.colors.transparent
        borderWidth: (root.active || root.checked) ? Theme.size.stroke : 0
        borderColor: Theme.colors.controlStroke
    }

    FluentIcon {
        visible: root.icon !== null
        anchors.centerIn: parent
        glyph: root.icon
        filled: root.iconFilled
        size: Theme.size.taskbarIcon
        color: root.iconColor
        scale: root.pressed ? Theme.pressScale : 1

        Behavior on scale {
            NumberAnimation { duration: Theme.motion.press; easing.type: Easing.OutBack; easing.overshoot: Theme.elevation.pressOvershoot }
        }
    }

    Image {
        visible: root.iconSource !== ""
        anchors.centerIn: parent
        source: root.iconSource
        sourceSize.width: Theme.size.taskbarIcon
        sourceSize.height: Theme.size.taskbarIcon
        width: Theme.size.taskbarIcon
        height: Theme.size.taskbarIcon
        scale: root.pressed ? Theme.pressScale : 1
        transform: Translate { id: lift }

        Behavior on scale {
            NumberAnimation { duration: Theme.motion.press; easing.type: Easing.OutBack; easing.overshoot: Theme.elevation.pressOvershoot }
        }
    }

    SequentialAnimation {
        id: launchBounce
        NumberAnimation { target: lift; property: "y"; to: -Theme.elevation.launchBounce * Theme.scale; duration: Theme.motion.bounce / 2; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
        NumberAnimation { target: lift; property: "y"; to: 0; duration: Theme.motion.bounce / 2; easing.type: Easing.OutBounce }
    }

    Connections {
        target: Apps
        enabled: root.appId !== "" && Theme.motion.bounce > 0
        function onLaunched(launchedId: string): void {
            if (launchedId === Apps.canonicalId(root.appId)) {
                launchBounce.restart();
            }
        }
    }

    Rectangle {
        opacity: root.running || root.urgent ? 1 : 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: root.active ? Theme.size.activeIndicatorWidth : Theme.size.openIndicatorWidth
        height: Theme.size.indicatorHeight
        radius: height / 2
        color: root.urgent ? Theme.colors.attention : root.active ? Theme.colors.accent : Theme.colors.textTertiary

        Behavior on opacity {
            NumberAnimation { duration: Theme.motion.normal; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
        }

        Behavior on width {
            NumberAnimation { duration: Theme.motion.normal; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
        }
    }

    ToolTip {
        target: root
        hovered: root.hovered
        text: root.toolTip
        previewWindowIds: root.previewWindowIds
    }
}
