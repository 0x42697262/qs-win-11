import QtQuick
import QtQuick.Effects
import qs.src.services
import qs.src.ui.theme

Item {
    id: root

    default property alias content: body.data
    property color fill: Theme.surfaceFill
    property real cornerRadius: Theme.radius.overlay
    property bool elevated: true

    RectangularShadow {
        visible: root.elevated && Appearance.anyShadows
        anchors.fill: surface
        radius: surface.radius
        blur: Theme.elevation.shadowBlur * Theme.scale
        offset.y: Theme.elevation.shadowOffset * Theme.scale
        color: Theme.colors.shadow
    }

    RectangularShadow {
        visible: root.elevated && Appearance.layeredShadows
        anchors.fill: surface
        radius: surface.radius
        blur: Theme.elevation.contactBlur * Theme.scale
        offset.y: Theme.elevation.contactOffset * Theme.scale
        color: Theme.colors.contactShadow
    }

    Rectangle {
        id: surface
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.fill
        border.width: Theme.size.stroke
        border.color: Theme.colors.surfaceStroke

        Item {
            visible: Appearance.edgeHighlight
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: root.cornerRadius + Theme.elevation.edgeHighlightWidth
            clip: true

            Rectangle {
                width: parent.width
                height: surface.height
                radius: surface.radius
                color: Theme.colors.transparent
                border.width: Theme.elevation.edgeHighlightWidth
                border.color: Theme.colors.edgeHighlight
            }
        }

        Item {
            id: body
            anchors.fill: parent
        }
    }
}
