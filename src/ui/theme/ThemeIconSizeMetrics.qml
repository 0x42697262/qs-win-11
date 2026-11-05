import QtQuick

QtObject {
    required property real scale
    required property var values

    readonly property real small: values.small * scale
    readonly property real medium: values.medium * scale
    readonly property real large: values.large * scale
    readonly property real xLarge: values.xLarge * scale
    readonly property real appTile: values.appTile * scale
    readonly property real hero: values.hero * scale
}
