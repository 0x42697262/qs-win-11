import QtQuick
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/system/indicators.mjs" as Indicators
import "../../../domain/catalog/icons.mjs" as Icons

Interactive {
    id: root

    property bool checked: false

    implicitWidth: row.implicitWidth + Theme.spacing.medium * 2
    implicitHeight: Theme.size.taskbarButton

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius.control
        color: root.pressed ? Theme.colors.subtleFillPressed : (root.hovered || root.checked) ? Theme.colors.subtleFillHover : Theme.colors.transparent
    }

    WheelHandler {
        onWheel: (event) => Audio.stepVolume(event.angleDelta.y > 0 ? 1 : -1)
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: Theme.size.clusterIconSpacing

        FluentIcon {
            glyph: NetworkControl.icon
        }

        FluentIcon {
            visible: Audio.available
            glyph: Indicators.volumeIcon(Audio.volume, Audio.muted)
        }

        FluentIcon {
            visible: Power.hasBattery
            glyph: Power.icon
        }

        FluentIcon {
            visible: DoNotDisturb.active || GameMode.silencing
            glyph: Icons.Icon.alertSnooze
        }

        FluentIcon {
            visible: StayAwake.active
            glyph: Icons.Icon.stayAwake
        }

        FluentIcon {
            visible: GameMode.active
            glyph: Icons.Icon.games
        }
    }
}
