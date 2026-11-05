import QtQuick
import qs.src.config
import QtQuick.Layouts
import qs.src.ui.theme
import qs.src.ui.components

FocusScope {
    id: root

    StartPanelPlacement {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacing.xLarge
            spacing: Theme.spacing.large

            SearchBox {
                id: searchBox
                Layout.fillWidth: true
                focus: true
                placeholder: Settings.values.text.start.searchPlaceholder
                onAccepted: results.launchSelected()
                onNavigateDown: results.moveSelection(1)
                onNavigateUp: results.moveSelection(-1)
            }

            SearchResultsView {
                id: results
                Layout.fillWidth: true
                Layout.fillHeight: true
                query: searchBox.text
            }
        }
    }
}
