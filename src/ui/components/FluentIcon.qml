import QtQuick
import qs.src.ui.theme
import "../../domain/catalog/icons.mjs" as Icons

Item {
    id: root

    required property var glyph
    property bool filled: false
    property real size: Theme.iconSize.medium
    property color color: Theme.colors.textPrimary
    readonly property var resolved: glyph ? IconSet.resolve(glyph, filled) : null
    readonly property bool isImage: resolved !== null && resolved.kind === Icons.IconSpecKind.Image

    implicitWidth: size
    implicitHeight: size

    Text {
        visible: !root.isImage
        anchors.centerIn: parent
        text: root.resolved ? root.resolved.text : ""
        font.family: root.resolved ? root.resolved.fontFamily : ""
        font.pixelSize: root.size
        color: root.color
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        textFormat: Text.PlainText
    }

    Image {
        visible: root.isImage
        anchors.fill: parent
        source: root.isImage ? root.resolved.source : ""
        sourceSize.width: root.size
        sourceSize.height: root.size
        fillMode: Image.PreserveAspectFit
    }
}
