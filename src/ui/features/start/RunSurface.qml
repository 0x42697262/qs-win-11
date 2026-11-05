pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/icons.mjs" as Icons

FocusScope {
    id: root

    readonly property var text: Settings.values.text.run
    property int historyIndex: -1

    function recall(step: int): void {
        const history = Run.history;
        if (history.length === 0) {
            return;
        }
        historyIndex = Math.max(-1, Math.min(history.length - 1, historyIndex + step));
        command.text = historyIndex < 0 ? "" : history[historyIndex];
    }

    FlyoutPanel {
        anchors.left: parent.left
        anchors.leftMargin: Theme.spacing.medium
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.spacing.medium
        width: Theme.size.runDialogWidth
        height: column.implicitHeight + Theme.spacing.xLarge * 2

        ColumnLayout {
            id: column
            anchors.fill: parent
            anchors.margins: Theme.spacing.xLarge
            spacing: Theme.spacing.medium

            RowLayout {
                spacing: Theme.spacing.small

                FluentIcon {
                    glyph: Icons.Icon.run
                    size: Theme.iconSize.medium
                    color: Theme.colors.accent
                }

                Label {
                    text: root.text.title
                    variant: UiEnums.TextVariant.Subtitle
                }
            }

            Label {
                Layout.fillWidth: true
                text: root.text.prompt
                wrapMode: Text.Wrap
                tone: UiEnums.TextTone.Secondary
            }

            SearchBox {
                id: command
                Layout.fillWidth: true
                focus: true
                icon: Icons.Icon.run
                placeholder: root.text.open
                onAccepted: Run.run(command.text)
                onNavigateUp: root.recall(1)
                onNavigateDown: root.recall(-1)
            }

            Repeater {
                model: command.text === "" ? Run.history.slice(0, Settings.values.tuning.runHistoryShown) : []

                ListItem {
                    required property string modelData
                    Layout.fillWidth: true
                    icon: Icons.Icon.history
                    title: modelData
                    onActivated: Run.run(modelData)
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.small

                Item { Layout.fillWidth: true }

                Button {
                    text: root.text.ok
                    variant: UiEnums.ButtonVariant.Accent
                    onActivated: Run.run(command.text)
                }

                Button {
                    text: root.text.cancel
                    onActivated: ShellState.close()
                }
            }
        }
    }
}
