import QtQuick
import qs.src.ui.theme

Rectangle {
    required property Item target
    property real cornerRadius: Theme.radius.control

    anchors.fill: target
    anchors.margins: -Theme.size.focusStroke
    radius: cornerRadius + Theme.size.focusStroke
    color: Theme.colors.transparent
    border.width: Theme.size.focusStroke
    border.color: Theme.colors.focusStroke
}
