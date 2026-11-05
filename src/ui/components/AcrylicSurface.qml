pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import "../../domain/catalog/system.mjs" as SystemCatalog

Item {
    id: root

    default property alias content: body.data
    property color fill: Theme.surfaceFill
    property real cornerRadius: Theme.radius.overlay
    property bool elevated: true
    property bool clipContent: false
    property bool showStroke: true
    property point windowOffset: Qt.point(0, 0)
    readonly property bool layered: Appearance.mica || Appearance.grain

    RectangularShadow {
        visible: root.elevated && Appearance.anyShadows
        anchors.fill: parent
        radius: root.cornerRadius
        blur: Theme.elevation.shadowBlur * Theme.scale
        offset.y: Theme.elevation.shadowOffset * Theme.scale
        color: Theme.colors.shadow
    }

    RectangularShadow {
        visible: root.elevated && Appearance.layeredShadows
        anchors.fill: parent
        radius: root.cornerRadius
        blur: Theme.elevation.contactBlur * Theme.scale
        offset.y: Theme.elevation.contactOffset * Theme.scale
        color: Theme.colors.contactShadow
    }

    Item {
        id: material
        anchors.fill: parent
        layer.enabled: root.layered
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: mask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1
        }

        MicaBackdrop {
            visible: Appearance.mica
            anchors.fill: parent
            windowOffset: root.windowOffset
        }

        SmoothRectangle {
            anchors.fill: parent
            radius: root.cornerRadius
            smoothingOverride: Theme.overlaySmoothing
            color: root.fill
        }

        Image {
            visible: Appearance.grain
            anchors.fill: parent
            source: Paths.shellAsset(SystemCatalog.TexturePath.noise)
            fillMode: Image.Tile
            opacity: Settings.values.backdrop.grainOpacity
            smooth: false
            sourceSize.width: Theme.size.grainTile * Settings.values.backdrop.grainScale
            sourceSize.height: Theme.size.grainTile * Settings.values.backdrop.grainScale
        }
    }

    SmoothRectangle {
        visible: root.showStroke
        anchors.fill: parent
        radius: root.cornerRadius
        smoothingOverride: Theme.overlaySmoothing
        borderWidth: Theme.size.stroke
        borderColor: Theme.colors.surfaceStroke
    }

    Item {
        visible: Appearance.edgeHighlight && root.showStroke
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
        layer.enabled: root.clipContent || root.layered
        radius: root.cornerRadius
        smoothingOverride: Theme.overlaySmoothing
        color: Theme.colors.textPrimary
    }
}
