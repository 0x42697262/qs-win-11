pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/tuning.mjs" as Tuning

FocusScope {
    id: root

    Keys.onTabPressed: WindowSwitcher.step(1)
    Keys.onBacktabPressed: WindowSwitcher.step(-1)
    Keys.onReturnPressed: WindowSwitcher.commit()
    Keys.onLeftPressed: WindowSwitcher.step(-1)
    Keys.onRightPressed: WindowSwitcher.step(1)

    FlyoutPanel {
        anchors.centerIn: parent
        width: grid.implicitWidth + Theme.spacing.large * 2
        height: grid.implicitHeight + Theme.spacing.large * 2

        GridLayout {
            id: grid
            anchors.centerIn: parent
            columns: Math.min(Tuning.ALT_TAB_COLUMNS, Math.max(1, WindowSwitcher.windows.length))
            columnSpacing: Theme.spacing.medium
            rowSpacing: Theme.spacing.medium

            Repeater {
                model: WindowSwitcher.windows

                WindowCard {
                    required property var modelData
                    required property int index
                    window: modelData
                    closable: false
                    cardWidth: Theme.size.altTabCard
                    selected: index === WindowSwitcher.selectedIndex
                    onActivated: {
                        WindowSwitcher.selectedIndex = index;
                        WindowSwitcher.commit();
                    }
                }
            }
        }
    }
}
