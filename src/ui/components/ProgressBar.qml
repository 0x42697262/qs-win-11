import QtQuick
import qs.src.ui.theme

Rectangle {
    required property real value
    property color barColor: Theme.colors.accent

    implicitHeight: Theme.size.sliderTrack
    radius: height / 2
    color: Theme.colors.controlStrongFill

    Rectangle {
        width: parent.width * Math.max(0, Math.min(1, parent.value))
        height: parent.height
        radius: parent.radius
        color: parent.barColor
    }
}
