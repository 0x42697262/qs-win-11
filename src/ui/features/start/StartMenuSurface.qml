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

    property var payload: null
    property bool showAllApps: payload ? payload.allApps === true : false
    property string menuAppId: ""
    property bool powerMenuOpen: false
    readonly property string query: searchBox.text

    function tileMenuItems(appId: string): list<var> {
        return [
            Apps.isPinnedToStart(appId)
                ? { text: Settings.values.text.start.unpinFromStart, icon: Icons.Icon.pinOff, action: () => Apps.toggleStartPin(appId) }
                : { text: Settings.values.text.start.pinToStart, icon: Icons.Icon.pin, action: () => Apps.toggleStartPin(appId) },
            Apps.isPinnedToTaskbar(appId)
                ? { text: Settings.values.text.taskbar.unpinFromTaskbar, icon: Icons.Icon.pinOff, action: () => Apps.toggleTaskbarPin(appId) }
                : { text: Settings.values.text.taskbar.pinToTaskbar, icon: Icons.Icon.pin, action: () => Apps.toggleTaskbarPin(appId) },
        ];
    }

    readonly property list<var> powerItems: [
        { text: Settings.values.text.session.lock, icon: Icons.Icon.lockClosed, action: () => { ShellState.close(); Session.lock(); } },
        { text: Settings.values.text.session.signOut, icon: Icons.Icon.signOut, action: () => { ShellState.close(); Session.signOut(); } },
        { text: Settings.values.text.session.sleep, icon: Icons.Icon.weatherMoon, action: () => { ShellState.close(); Session.suspend(); } },
        { text: Settings.values.text.session.shutDown, icon: Icons.Icon.power, action: () => { ShellState.close(); Session.powerOff(); } },
        { text: Settings.values.text.session.restart, icon: Icons.Icon.arrowClockwise, action: () => { ShellState.close(); Session.restart(); } },
    ]

    StartPanelPlacement {
        id: panel

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            SearchBox {
                id: searchBox
                Layout.fillWidth: true
                Layout.margins: Theme.spacing.xLarge
                Layout.bottomMargin: Theme.spacing.large
                focus: true
                placeholder: Settings.values.text.start.searchPlaceholder
                onAccepted: results.launchSelected()
                onNavigateDown: results.moveSelection(1)
                onNavigateUp: results.moveSelection(-1)
            }

            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: Theme.spacing.xxLarge
                Layout.rightMargin: Theme.spacing.xxLarge
                currentIndex: root.query !== "" ? 2 : root.showAllApps ? 1 : 0

                ColumnLayout {
                    spacing: Theme.spacing.small

                    RowLayout {
                        Layout.fillWidth: true
                        Label { text: Settings.values.text.start.pinned; variant: UiEnums.TextVariant.BodyStrong; Layout.fillWidth: true }
                        Button { text: Settings.values.text.start.allApps; icon: Icons.Icon.chevronRight; onActivated: root.showAllApps = true }
                    }

                    GridLayout {
                        columns: Settings.values.tuning.startPinnedColumns
                        columnSpacing: 0
                        rowSpacing: 0

                        Repeater {
                            model: Apps.startPinned.slice(0, Settings.values.tuning.startPinnedColumns * Settings.values.tuning.startPinnedRows)

                            AppTile {
                                required property string modelData
                                appId: modelData
                                onMenuRequested: (appId) => root.menuAppId = appId
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }

                    ColumnLayout {
                        visible: Settings.values.startMenu.showRecommended
                        Layout.fillWidth: true
                        spacing: Theme.spacing.small

                        Label { text: Settings.values.text.start.recommended; variant: UiEnums.TextVariant.BodyStrong }

                        Label {
                            visible: RecentFiles.files.length === 0
                            text: Settings.values.text.start.noRecommended
                            tone: UiEnums.TextTone.Secondary
                        }

                        GridLayout {
                            Layout.fillWidth: true
                            columns: Settings.values.tuning.startRecommendedColumns
                            columnSpacing: Theme.spacing.small
                            rowSpacing: Theme.spacing.xxSmall

                            Repeater {
                                model: RecentFiles.files

                                ListItem {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: Theme.size.searchResultsWidth
                                    icon: Icons.Icon.document
                                    title: modelData.name
                                    onActivated: {
                                        ShellState.close();
                                        Session.openUri(modelData.uri);
                                    }
                                }
                            }
                        }
                    }
                }

                ColumnLayout {
                    spacing: Theme.spacing.small

                    RowLayout {
                        Layout.fillWidth: true
                        Label { text: Settings.values.text.start.allApps; variant: UiEnums.TextVariant.BodyStrong; Layout.fillWidth: true }
                        Button { text: Settings.values.text.start.back; icon: Icons.Icon.chevronLeft; onActivated: root.showAllApps = false }
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: Theme.spacing.xxSmall
                        model: Apps.visibleEntries
                        section.property: "name"
                        section.criteria: ViewSection.FirstCharacter
                        section.delegate: Label {
                            required property string section
                            text: section.toUpperCase()
                            variant: UiEnums.TextVariant.BodyStrong
                            height: implicitHeight + Theme.spacing.small
                        }

                        delegate: ListItem {
                            required property var modelData
                            width: ListView.view.width
                            iconSource: Apps.iconSource(modelData.id)
                            title: modelData.name
                            acceptRightClick: true
                            onActivated: {
                                ShellState.close();
                                Apps.launch(modelData.id);
                            }
                            onRightClicked: root.menuAppId = modelData.id
                        }
                    }
                }

                SearchResultsView {
                    id: results
                    query: root.query
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.size.startFooterHeight
                Layout.topMargin: Theme.spacing.large
                color: Theme.colors.cardBackgroundSecondary
                bottomLeftRadius: Theme.radius.overlay
                bottomRightRadius: Theme.radius.overlay

                Divider { anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.spacing.xxxLarge
                    anchors.rightMargin: Theme.spacing.xxxLarge
                    spacing: Theme.spacing.medium

                    Avatar { source: UserAccount.avatarSource; initial: UserAccount.initial }
                    Label { text: UserAccount.name; Layout.fillWidth: true }

                    IconButton {
                        id: powerButton
                        icon: Icons.Icon.power
                        onActivated: root.powerMenuOpen = !root.powerMenuOpen
                    }
                }
            }
        }

        InlineMenu {
            visible: root.powerMenuOpen
            items: root.powerItems
            anchors.right: parent.right
            anchors.rightMargin: Theme.spacing.large
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.size.startFooterHeight
            onChosen: root.powerMenuOpen = false
        }

        InlineMenu {
            visible: root.menuAppId !== ""
            items: root.menuAppId !== "" ? root.tileMenuItems(root.menuAppId) : []
            anchors.centerIn: parent
            onChosen: root.menuAppId = ""
        }
    }
}
