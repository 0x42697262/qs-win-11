pragma ComponentBehavior: Bound
import QtQuick
import qs.src.config
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/search/searchEntries.mjs" as SearchEntries
import "../../../domain/settings/presentation.mjs" as Presentation

RowLayout {
    id: root

    required property string query
    readonly property list<var> results: Search.entries(query)
    property int selectedIndex: 0
    readonly property var selected: results.length > 0 ? results[Math.min(selectedIndex, results.length - 1)] : null
    readonly property bool selectedIsApp: selected !== null && selected.kind === SearchEntries.SearchEntryKind.App
    readonly property bool selectedIsCalculation: selected !== null && selected.kind === SearchEntries.SearchEntryKind.Calculation

    function launchSelected(): void {
        Search.activate(selected);
    }

    function moveSelection(step: int): void {
        selectedIndex = Math.max(0, Math.min(results.length - 1, selectedIndex + step));
    }

    function iconOf(entry: var): var {
        if (entry.kind === SearchEntries.SearchEntryKind.Calculation) {
            return Icons.Icon.calculator;
        }
        return entry.kind === SearchEntries.SearchEntryKind.Setting ? Icons.Icon.settings : null;
    }

    function subtitleOf(entry: var, index: int): string {
        if (entry.kind === SearchEntries.SearchEntryKind.Calculation) {
            return `${Settings.values.text.search.calculator} · ${entry.subtitle}`;
        }
        if (entry.kind === SearchEntries.SearchEntryKind.Setting) {
            return `${Settings.values.text.search.setting} · ${Presentation.humanize(entry.subtitle)}`;
        }
        return index === 0 ? Settings.values.text.search.application : "";
    }

    onQueryChanged: selectedIndex = 0
    spacing: Theme.spacing.large

    ColumnLayout {
        Layout.fillHeight: true
        Layout.fillWidth: false
        Layout.preferredWidth: Theme.size.searchResultsWidth
        Layout.maximumWidth: Theme.size.searchResultsWidth
        spacing: Theme.spacing.xxSmall

        Label {
            visible: root.results.length === 0 || root.results[0].kind !== SearchEntries.SearchEntryKind.Setting
            text: root.results.length > 0 ? Settings.values.text.search.bestMatch : root.query === "" ? Settings.values.text.search.typeToSearch : Settings.values.text.search.noResults
            variant: UiEnums.TextVariant.BodyStrong
        }

        Repeater {
            model: root.results

            ColumnLayout {
                id: row

                required property var modelData
                required property int index
                readonly property bool startsSettings: modelData.kind === SearchEntries.SearchEntryKind.Setting && (index === 0 || root.results[index - 1].kind !== SearchEntries.SearchEntryKind.Setting)

                Layout.fillWidth: true
                spacing: Theme.spacing.xxSmall

                Label {
                    visible: row.startsSettings
                    Layout.topMargin: Theme.spacing.small
                    text: Settings.values.text.search.settings
                    variant: UiEnums.TextVariant.BodyStrong
                }

                ListItem {
                    Layout.fillWidth: true
                    icon: root.iconOf(row.modelData)
                    iconSource: row.modelData.kind === SearchEntries.SearchEntryKind.App ? Apps.iconSource(row.modelData.id) : ""
                    title: row.modelData.title
                    subtitle: root.subtitleOf(row.modelData, row.index)
                    selected: row.index === root.selectedIndex
                    onActivated: {
                        root.selectedIndex = row.index;
                        root.launchSelected();
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }

    Card {
        visible: root.selected !== null
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumWidth: Theme.size.searchResultsWidth
        Layout.preferredWidth: Theme.size.searchResultsWidth

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacing.xLarge
            spacing: Theme.spacing.medium

            Image {
                visible: root.selectedIsApp
                Layout.alignment: Qt.AlignHCenter
                source: root.selectedIsApp ? Apps.iconSource(root.selected.id) : ""
                sourceSize.width: Theme.iconSize.hero
                sourceSize.height: Theme.iconSize.hero
                Layout.preferredWidth: Theme.iconSize.hero
                Layout.preferredHeight: Theme.iconSize.hero
            }

            FluentIcon {
                visible: root.selected !== null && !root.selectedIsApp
                Layout.alignment: Qt.AlignHCenter
                glyph: root.selected ? root.iconOf(root.selected) : null
                size: Theme.iconSize.hero
                color: Theme.colors.accent
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                text: root.selected ? root.selected.title : ""
                variant: root.selectedIsCalculation ? UiEnums.TextVariant.Title : UiEnums.TextVariant.Subtitle
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                text: root.selected ? root.subtitleOf(root.selected, 0) : ""
                tone: UiEnums.TextTone.Secondary
            }

            Divider { Layout.fillWidth: true }

            ListItem {
                Layout.fillWidth: true
                icon: root.selectedIsCalculation ? Icons.Icon.copy : root.selectedIsApp ? Icons.Icon.open : Icons.Icon.settings
                title: root.selectedIsCalculation ? Settings.values.text.search.copyResult : root.selectedIsApp ? Settings.values.text.search.open : Settings.values.text.search.openSetting
                onActivated: root.launchSelected()
            }

            ListItem {
                visible: root.selectedIsApp
                Layout.fillWidth: true
                icon: root.selectedIsApp && Apps.isPinnedToStart(root.selected.id) ? Icons.Icon.pinOff : Icons.Icon.pin
                title: root.selectedIsApp && Apps.isPinnedToStart(root.selected.id) ? Settings.values.text.start.unpinFromStart : Settings.values.text.start.pinToStart
                onActivated: Apps.toggleStartPin(root.selected.id)
            }

            ListItem {
                visible: root.selectedIsApp
                Layout.fillWidth: true
                icon: root.selectedIsApp && Apps.isPinnedToTaskbar(root.selected.id) ? Icons.Icon.pinOff : Icons.Icon.pin
                title: root.selectedIsApp && Apps.isPinnedToTaskbar(root.selected.id) ? Settings.values.text.taskbar.unpinFromTaskbar : Settings.values.text.taskbar.pinToTaskbar
                onActivated: Apps.toggleTaskbarPin(root.selected.id)
            }

            Item { Layout.fillHeight: true }
        }
    }
}
