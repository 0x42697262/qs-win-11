import QtQuick
import QtQuick.Layouts
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/strings.mjs" as Strings

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
                placeholder: Strings.Strings.start.searchPlaceholder
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
