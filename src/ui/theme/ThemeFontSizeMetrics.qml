import QtQuick

QtObject {
    required property real scale
    required property var values

    readonly property real caption: values.caption * scale
    readonly property real body: values.body * scale
    readonly property real bodyLarge: values.bodyLarge * scale
    readonly property real subtitle: values.subtitle * scale
    readonly property real title: values.title * scale
    readonly property real titleLarge: values.titleLarge * scale
    readonly property real display: values.display * scale
}
