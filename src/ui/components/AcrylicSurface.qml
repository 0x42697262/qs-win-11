import QtQuick
import QtQuick.Effects
import qs.src.ui.theme

Item {
    id: root

    default property alias content: body.data
    property color fill: Theme.colors.flyoutBackground
    property real cornerRadius: Theme.radius.overlay
    property bool elevated: true

    RectangularShadow {
        visible: root.elevated
        anchors.fill: surface
        radius: surface.radius
        blur: Theme.spacing.xxLarge
        offset.y: Theme.spacing.small
        color: Theme.colors.smokeOverlay
    }

    Rectangle {
        id: surface
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.fill
        border.width: Theme.size.stroke
        border.color: Theme.colors.surfaceStroke

        Item {
            id: body
            anchors.fill: parent
        }
    }
}
