import QtQuick

QtObject {
    required property real scale
    required property var values

    readonly property real control: values.control * scale
    readonly property real overlay: values.overlay * scale
    readonly property real round: values.round * scale
}
