pragma ComponentBehavior: Bound
import QtQuick
import qs.src.config
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/icons.mjs" as Icons

RowLayout {
    id: root

    required property string query
    readonly property list<var> results: Apps.search(query)
    property int selectedIndex: 0
    readonly property var selected: results.length > 0 ? results[Math.min(selectedIndex, results.length - 1)] : null

    function launchSelected(): void {
        if (selected) {
            ShellState.close();
            Apps.launch(selected.id);
        }
    }

    function moveSelection(step: int): void {
        selectedIndex = Math.max(0, Math.min(results.length - 1, selectedIndex + step));
    }

    onQueryChanged: selectedIndex = 0
    spacing: Theme.spacing.large

    ColumnLayout {
        Layout.fillHeight: true
        Layout.preferredWidth: Theme.size.searchResultsWidth
        spacing: Theme.spacing.xxSmall

        Label {
            text: root.results.length > 0 ? Settings.values.text.search.bestMatch : root.query === "" ? Settings.values.text.search.typeToSearch : Settings.values.text.search.noResults
            variant: UiEnums.TextVariant.BodyStrong
        }

        Repeater {
            model: root.results

            ListItem {
                required property var modelData
                required property int index

                Layout.fillWidth: true
                iconSource: Apps.iconSource(modelData.id)
                title: modelData.name
                subtitle: index === 0 ? Settings.values.text.search.application : ""
                selected: index === root.selectedIndex
                onActivated: {
                    root.selectedIndex = index;
                    root.launchSelected();
                }
            }
        }

        Item { Layout.fillHeight: true }
    }

    Card {
        visible: root.selected !== null
        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacing.xLarge
            spacing: Theme.spacing.medium

            Image {
                Layout.alignment: Qt.AlignHCenter
                source: root.selected ? Apps.iconSource(root.selected.id) : ""
                sourceSize.width: Theme.iconSize.hero
                sourceSize.height: Theme.iconSize.hero
                Layout.preferredWidth: Theme.iconSize.hero
                Layout.preferredHeight: Theme.iconSize.hero
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: root.selected ? root.selected.name : ""
                variant: UiEnums.TextVariant.Subtitle
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: Settings.values.text.search.application
                tone: UiEnums.TextTone.Secondary
            }

            Divider { Layout.fillWidth: true }

            ListItem {
                Layout.fillWidth: true
                icon: Icons.Icon.open
                title: Settings.values.text.search.open
                onActivated: root.launchSelected()
            }

            ListItem {
                Layout.fillWidth: true
                icon: root.selected && Apps.isPinnedToStart(root.selected.id) ? Icons.Icon.pinOff : Icons.Icon.pin
                title: root.selected && Apps.isPinnedToStart(root.selected.id) ? Settings.values.text.start.unpinFromStart : Settings.values.text.start.pinToStart
                onActivated: Apps.toggleStartPin(root.selected.id)
            }

            ListItem {
                Layout.fillWidth: true
                icon: root.selected && Apps.isPinnedToTaskbar(root.selected.id) ? Icons.Icon.pinOff : Icons.Icon.pin
                title: root.selected && Apps.isPinnedToTaskbar(root.selected.id) ? Settings.values.text.taskbar.unpinFromTaskbar : Settings.values.text.taskbar.pinToTaskbar
                onActivated: Apps.toggleTaskbarPin(root.selected.id)
            }

            Item { Layout.fillHeight: true }
        }
    }
}
