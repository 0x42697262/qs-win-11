import QtQuick
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/tokens.mjs" as Tokens

Interactive {
    id: root

    property var icon: null
    property bool iconFilled: false
    property color iconColor: Theme.colors.textPrimary
    property string iconSource: ""
    property string toolTip: ""
    property bool running: false
    property bool active: false
    property bool urgent: false
    property bool checked: false

    implicitWidth: Theme.size.taskbarButton
    implicitHeight: Theme.size.taskbarButton

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius.control
        color: root.pressed ? Theme.colors.subtleFillPressed : (root.hovered || root.active || root.checked) ? Theme.colors.subtleFillHover : Theme.colors.transparent
        border.width: (root.active || root.checked) ? Theme.size.stroke : 0
        border.color: Theme.colors.controlStroke
    }

    FluentIcon {
        visible: root.icon !== null
        anchors.centerIn: parent
        glyph: root.icon
        filled: root.iconFilled
        size: Theme.size.taskbarIcon
        color: root.iconColor
        scale: root.pressed ? Tokens.PRESS_SCALE : 1
    }

    Image {
        visible: root.iconSource !== ""
        anchors.centerIn: parent
        source: root.iconSource
        sourceSize.width: Theme.size.taskbarIcon
        sourceSize.height: Theme.size.taskbarIcon
        width: Theme.size.taskbarIcon
        height: Theme.size.taskbarIcon
    }

    Rectangle {
        visible: root.running || root.urgent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: root.active ? Theme.size.activeIndicatorWidth : Theme.size.openIndicatorWidth
        height: Theme.size.indicatorHeight
        radius: height / 2
        color: root.urgent ? Theme.colors.attention : root.active ? Theme.colors.accent : Theme.colors.textTertiary

        Behavior on width {
            NumberAnimation { duration: Theme.motion.normal; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
        }
    }

    ToolTip {
        target: root
        hovered: root.hovered
        text: root.toolTip
    }
}
