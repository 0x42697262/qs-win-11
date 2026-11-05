pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/strings.mjs" as Strings
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

FocusScope {
    id: root

    readonly property list<var> actions: [
        { text: Strings.Strings.session.lock, icon: Icons.Icon.lockClosed, run: () => Session.lock() },
        { text: Strings.Strings.session.signOut, icon: Icons.Icon.signOut, run: () => Session.signOut() },
        { text: Strings.Strings.session.sleep, icon: Icons.Icon.weatherMoon, run: () => Session.suspend() },
        { text: Strings.Strings.session.restart, icon: Icons.Icon.arrowClockwise, run: () => Session.restart() },
        { text: Strings.Strings.session.shutDown, icon: Icons.Icon.power, run: () => Session.powerOff() },
    ]

    Rectangle {
        anchors.fill: parent
        color: Theme.colors.smokeOverlay
    }

    MouseArea {
        anchors.fill: parent
        onClicked: ShellState.close()
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Theme.spacing.xxLarge

        RowLayout {
            spacing: Theme.spacing.large

            Repeater {
                model: root.actions

                Interactive {
                    id: action

                    required property var modelData
                    required property int index

                    implicitWidth: Theme.size.sessionButton
                    implicitHeight: Theme.size.sessionButton
                    focus: index === 0
                    onActivated: {
                        ShellState.close();
                        modelData.run();
                    }

                    AcrylicSurface {
                        anchors.fill: parent
                        fill: action.hovered ? Theme.colors.controlFillHover : Theme.colors.flyoutBackground
                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Theme.spacing.medium

                        FluentIcon {
                            Layout.alignment: Qt.AlignHCenter
                            glyph: action.modelData.icon
                            size: Theme.iconSize.hero
                        }

                        Label {
                            Layout.alignment: Qt.AlignHCenter
                            text: action.modelData.text
                        }
                    }
                }
            }
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text: Strings.Strings.sessionMenu.cancel
            variant: UiEnums.ButtonVariant.Standard
            onActivated: ShellState.close()
        }
    }
}
