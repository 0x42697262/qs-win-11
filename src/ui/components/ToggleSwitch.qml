import QtQuick
import qs.src.ui.theme

Interactive {
    id: root

    required property bool checked
    signal toggled(bool checked)

    implicitWidth: Theme.size.toggleWidth
    implicitHeight: Theme.size.toggleHeight
    onActivated: toggled(!checked)

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: root.checked ? (root.hovered ? Theme.colors.accentHover : Theme.colors.accent) : (root.hovered ? Theme.colors.subtleFillHover : Theme.colors.transparent)
        border.width: root.checked ? 0 : Theme.size.stroke
        border.color: Theme.colors.controlStrongStroke

        Rectangle {
            readonly property real knobSize: root.pressed ? Theme.size.toggleKnobPressed : Theme.size.toggleKnob
            readonly property real inset: (parent.height - knobSize) / 2

            width: knobSize
            height: knobSize
            radius: knobSize / 2
            anchors.verticalCenter: parent.verticalCenter
            x: root.checked ? parent.width - knobSize - inset : inset
            color: root.checked ? Theme.colors.textOnAccent : Theme.colors.controlStrongFill

            Behavior on x {
                NumberAnimation { duration: Theme.motion.normal; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
            }
        }
    }
}
