pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/strings.mjs" as Strings
import "../../../domain/catalog/features.mjs" as FeatureCatalog
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/tuning.mjs" as Tuning

FocusScope {
    id: root

    readonly property bool hasWorkspaces: Windows.capabilities.includes(FeatureCatalog.Capability.Workspaces)
    readonly property int activeWorkspaceId: (Windows.workspaces.find(workspace => workspace.focused) ?? { id: -1 }).id
    readonly property list<var> shownWindows: hasWorkspaces ? Windows.windows.filter(window => window.workspaceId === activeWorkspaceId) : Windows.windows

    Rectangle {
        anchors.fill: parent
        color: Theme.colors.smokeOverlay
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing.xxxLarge
        spacing: Theme.spacing.xxLarge

        Item { Layout.fillHeight: true }

        Label {
            visible: root.shownWindows.length === 0
            Layout.alignment: Qt.AlignHCenter
            text: Strings.Strings.taskView.noWindows
            variant: UiEnums.TextVariant.Subtitle
        }

        GridLayout {
            Layout.alignment: Qt.AlignHCenter
            columns: Tuning.TASK_VIEW_COLUMNS
            columnSpacing: Theme.spacing.large
            rowSpacing: Theme.spacing.large

            Repeater {
                model: root.shownWindows

                WindowCard {
                    required property var modelData
                    window: modelData
                    selected: modelData.active
                    onActivated: {
                        ShellState.close();
                        Windows.focus(modelData.id);
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }

        RowLayout {
            visible: root.hasWorkspaces
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.spacing.medium

            Repeater {
                model: Windows.workspaces

                Interactive {
                    id: workspace

                    required property var modelData

                    implicitWidth: Theme.size.workspaceCard
                    implicitHeight: Theme.size.buttonHeight * 2
                    onActivated: Windows.activateWorkspace(modelData.id)

                    AcrylicSurface {
                        anchors.fill: parent
                        elevated: false
                        fill: workspace.modelData.focused ? Theme.colors.controlFillHover : Theme.colors.flyoutBackground
                    }

                    Label {
                        anchors.centerIn: parent
                        text: Strings.Strings.taskView.desktop.split(Strings.COUNT_PLACEHOLDER).join(workspace.modelData.name)
                        variant: workspace.modelData.focused ? UiEnums.TextVariant.BodyStrong : UiEnums.TextVariant.Body
                    }
                }
            }
        }
    }
}
