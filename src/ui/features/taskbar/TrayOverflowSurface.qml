pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/tuning.mjs" as Tuning

FocusScope {
    id: root

    required property real anchorX

    FlyoutPanel {
        width: grid.implicitWidth + Theme.spacing.small * 2
        height: grid.implicitHeight + Theme.spacing.small * 2
        x: Math.max(Theme.spacing.small, Math.min(root.anchorX - width / 2, root.width - width - Theme.spacing.small))
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.spacing.medium

        Grid {
            id: grid
            anchors.centerIn: parent
            columns: Tuning.TRAY_OVERFLOW_COLUMNS
            spacing: Theme.spacing.xxSmall

            Repeater {
                model: SystemTray.items

                Interactive {
                    id: cell

                    required property SystemTrayItem modelData

                    width: Theme.size.trayCell
                    height: Theme.size.trayCell
                    acceptRightClick: true
                    onActivated: modelData.onlyMenu ? showMenu() : modelData.activate()
                    onRightClicked: if (modelData.hasMenu) showMenu()

                    function showMenu(): void {
                        const point = cell.mapToItem(null, 0, 0);
                        modelData.display(QsWindow.window, point.x, point.y);
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.radius.control
                        color: cell.hovered ? Theme.colors.subtleFillHover : Theme.colors.transparent
                    }

                    Image {
                        anchors.centerIn: parent
                        source: cell.modelData.icon
                        sourceSize.width: Theme.size.trayIcon
                        sourceSize.height: Theme.size.trayIcon
                        width: Theme.size.trayIcon
                        height: Theme.size.trayIcon
                    }

                    ToolTip {
                        target: cell
                        hovered: cell.hovered
                        text: cell.modelData.tooltipTitle !== "" ? cell.modelData.tooltipTitle : cell.modelData.title
                    }

                }
            }
        }
    }
}
