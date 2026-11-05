import QtQuick

QtObject {
    required property real scale
    required property var values

    readonly property real xxSmall: values.xxSmall * scale
    readonly property real xSmall: values.xSmall * scale
    readonly property real small: values.small * scale
    readonly property real medium: values.medium * scale
    readonly property real large: values.large * scale
    readonly property real xLarge: values.xLarge * scale
    readonly property real xxLarge: values.xxLarge * scale
    readonly property real xxxLarge: values.xxxLarge * scale
}
