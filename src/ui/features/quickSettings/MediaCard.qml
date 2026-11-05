import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

Card {
    id: root

    required property MprisPlayer player

    implicitHeight: row.implicitHeight + Theme.spacing.medium * 2

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.margins: Theme.spacing.medium
        spacing: Theme.spacing.medium

        Rectangle {
            Layout.preferredWidth: Theme.size.mediaArt
            Layout.preferredHeight: Theme.size.mediaArt
            radius: Theme.radius.control
            color: Theme.colors.controlFill
            clip: true

            FluentIcon {
                anchors.centerIn: parent
                visible: art.status !== Image.Ready
                glyph: Icons.Icon.play
                size: Theme.iconSize.xLarge
            }

            Image {
                id: art
                anchors.fill: parent
                source: root.player.trackArtUrl
                fillMode: Image.PreserveAspectCrop
                sourceSize.width: Theme.size.mediaArt
                sourceSize.height: Theme.size.mediaArt
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.xxSmall

            Label {
                Layout.fillWidth: true
                text: root.player.trackTitle !== "" ? root.player.trackTitle : root.player.identity
                variant: UiEnums.TextVariant.BodyStrong
            }

            Label {
                Layout.fillWidth: true
                text: root.player.trackArtist
                variant: UiEnums.TextVariant.Caption
                tone: UiEnums.TextTone.Secondary
            }

            RowLayout {
                spacing: Theme.spacing.xSmall

                IconButton {
                    icon: Icons.Icon.previous
                    filled: true
                    enabledState: root.player.canGoPrevious
                    onActivated: root.player.previous()
                }

                IconButton {
                    icon: root.player.isPlaying ? Icons.Icon.pause : Icons.Icon.play
                    filled: true
                    enabledState: root.player.canTogglePlaying
                    onActivated: root.player.togglePlaying()
                }

                IconButton {
                    icon: Icons.Icon.next
                    filled: true
                    enabledState: root.player.canGoNext
                    onActivated: root.player.next()
                }
            }
        }
    }
}
