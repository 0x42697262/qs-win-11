pragma ComponentBehavior: Bound
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
    property bool clipContent: false

    RectangularShadow {
        visible: root.elevated && Appearance.anyShadows
        anchors.fill: surface
        radius: root.cornerRadius
        blur: Theme.elevation.shadowBlur * Theme.scale
        offset.y: Theme.elevation.shadowOffset * Theme.scale
        color: Theme.colors.shadow
    }

    RectangularShadow {
        visible: root.elevated && Appearance.layeredShadows
        anchors.fill: surface
        radius: root.cornerRadius
        blur: Theme.elevation.contactBlur * Theme.scale
        offset.y: Theme.elevation.contactOffset * Theme.scale
        color: Theme.colors.contactShadow
    }

    SmoothRectangle {
        id: surface
        anchors.fill: parent
        radius: root.cornerRadius
        smoothingOverride: Theme.overlaySmoothing
        color: root.fill
        borderWidth: Theme.size.stroke
        borderColor: Theme.colors.surfaceStroke
    }

    Item {
        visible: Appearance.edgeHighlight
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: root.cornerRadius + Theme.elevation.edgeHighlightWidth
        clip: true

        SmoothRectangle {
            width: parent.width
            height: root.height
            radius: root.cornerRadius
            smoothingOverride: Theme.overlaySmoothing
            borderWidth: Theme.elevation.edgeHighlightWidth
            borderColor: Theme.colors.edgeHighlight
        }
    }

    Item {
        id: body
        anchors.fill: parent
        layer.enabled: root.clipContent
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: mask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1
        }
    }

    SmoothRectangle {
        id: mask
        anchors.fill: parent
        visible: false
        layer.enabled: root.clipContent
        radius: root.cornerRadius
        smoothingOverride: Theme.overlaySmoothing
        color: Theme.colors.textPrimary
    }
}
