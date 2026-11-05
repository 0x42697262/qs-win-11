pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/strings.mjs" as Strings
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/tuning.mjs" as Tuning

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
                ? { text: Strings.Strings.start.unpinFromStart, icon: Icons.Icon.pinOff, action: () => Apps.toggleStartPin(appId) }
                : { text: Strings.Strings.start.pinToStart, icon: Icons.Icon.pin, action: () => Apps.toggleStartPin(appId) },
            Apps.isPinnedToTaskbar(appId)
                ? { text: Strings.Strings.taskbar.unpinFromTaskbar, icon: Icons.Icon.pinOff, action: () => Apps.toggleTaskbarPin(appId) }
                : { text: Strings.Strings.taskbar.pinToTaskbar, icon: Icons.Icon.pin, action: () => Apps.toggleTaskbarPin(appId) },
        ];
    }

    readonly property list<var> powerItems: [
        { text: Strings.Strings.session.lock, icon: Icons.Icon.lockClosed, action: () => { ShellState.close(); Session.lock(); } },
        { text: Strings.Strings.session.signOut, icon: Icons.Icon.signOut, action: () => { ShellState.close(); Session.signOut(); } },
        { text: Strings.Strings.session.sleep, icon: Icons.Icon.weatherMoon, action: () => { ShellState.close(); Session.suspend(); } },
        { text: Strings.Strings.session.shutDown, icon: Icons.Icon.power, action: () => { ShellState.close(); Session.powerOff(); } },
        { text: Strings.Strings.session.restart, icon: Icons.Icon.arrowClockwise, action: () => { ShellState.close(); Session.restart(); } },
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
                placeholder: Strings.Strings.start.searchPlaceholder
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
                        Label { text: Strings.Strings.start.pinned; variant: UiEnums.TextVariant.BodyStrong; Layout.fillWidth: true }
                        Button { text: Strings.Strings.start.allApps; icon: Icons.Icon.chevronRight; onActivated: root.showAllApps = true }
                    }

                    GridLayout {
                        columns: Tuning.START_PINNED_COLUMNS
                        columnSpacing: 0
                        rowSpacing: 0

                        Repeater {
                            model: Apps.startPinned.slice(0, Tuning.START_PINNED_COLUMNS * Tuning.START_PINNED_ROWS)

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

                        Label { text: Strings.Strings.start.recommended; variant: UiEnums.TextVariant.BodyStrong }

                        Label {
                            visible: RecentFiles.files.length === 0
                            text: Strings.Strings.start.noRecommended
                            tone: UiEnums.TextTone.Secondary
                        }

                        GridLayout {
                            Layout.fillWidth: true
                            columns: Tuning.START_RECOMMENDED_COLUMNS
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
                        Label { text: Strings.Strings.start.allApps; variant: UiEnums.TextVariant.BodyStrong; Layout.fillWidth: true }
                        Button { text: Strings.Strings.start.back; icon: Icons.Icon.chevronLeft; onActivated: root.showAllApps = false }
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
