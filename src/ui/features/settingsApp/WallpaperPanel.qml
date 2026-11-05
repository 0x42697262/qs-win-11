pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/strings.mjs" as Strings
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/system.mjs" as SystemCatalog

ColumnLayout {
    id: root

    readonly property var text: Settings.values.text.wallpaper

    spacing: Theme.spacing.small

    onVisibleChanged: if (visible) WallpaperGallery.refresh()
    Component.onCompleted: WallpaperGallery.refresh()

    RowLayout {
        Layout.fillWidth: true

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Label {
                text: root.text.title
                variant: UiEnums.TextVariant.BodyStrong
            }

            Label {
                Layout.fillWidth: true
                elide: Text.ElideMiddle
                text: root.text.folder.replace(Strings.NAME_PLACEHOLDER, WallpaperGallery.directory)
                tone: UiEnums.TextTone.Secondary
                variant: UiEnums.TextVariant.Caption
            }
        }

        Button {
            text: root.text.refresh
            icon: Icons.Icon.arrowClockwise
            onActivated: WallpaperGallery.refresh()
        }
    }

    Label {
        visible: WallpaperGallery.loaded && WallpaperGallery.files.length === 0
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
        text: root.text.empty
        tone: UiEnums.TextTone.Secondary
    }

    GridLayout {
        columns: Settings.values.tuning.wallpaperPickerColumns
        columnSpacing: Theme.spacing.small
        rowSpacing: Theme.spacing.small

        Repeater {
            model: WallpaperGallery.files

            Interactive {
                id: thumbnail

                required property var modelData
                required property int index
                readonly property bool current: modelData.path === Settings.values.wallpaper.path

                implicitWidth: Theme.size.wallpaperThumbWidth
                implicitHeight: Theme.size.wallpaperThumbHeight
                onActivated: WallpaperGallery.set(modelData.path)

                Appear {
                    target: thumbnail
                    index: thumbnail.index
                }

                Image {
                    id: picture
                    anchors.fill: parent
                    anchors.margins: Theme.size.stroke * 2
                    source: `${SystemCatalog.FILE_URL_PREFIX}${thumbnail.modelData.path}`
                    sourceSize.width: Theme.size.wallpaperThumbWidth * 2
                    sourceSize.height: Theme.size.wallpaperThumbHeight * 2
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    cache: true
                    scale: thumbnail.pressed ? Theme.pressScale : 1

                    Behavior on scale {
                        NumberAnimation { duration: Theme.motion.press; easing.type: Easing.OutBack; easing.overshoot: Theme.elevation.pressOvershoot }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: Theme.radius.control
                    color: Theme.colors.transparent
                    border.width: thumbnail.current ? Theme.size.stroke * 2 : thumbnail.hovered ? Theme.size.stroke : 0
                    border.color: thumbnail.current ? Theme.colors.accent : Theme.colors.controlStroke
                }

                ToolTip {
                    target: thumbnail
                    hovered: thumbnail.hovered
                    text: thumbnail.current ? `${thumbnail.modelData.name} · ${root.text.current}` : thumbnail.modelData.name
                }
            }
        }
    }
}
