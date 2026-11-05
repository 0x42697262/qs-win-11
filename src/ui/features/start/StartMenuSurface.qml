pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/enums.mjs" as Enums
import "../../../domain/catalog/settingsSchema.mjs" as Schema

FocusScope {
    id: root

    property var payload: null
    property string menuAppId: ""
    property bool powerMenuOpen: false
    property bool pinnedExpanded: false
    property var expandedCategories: ({})
    readonly property string query: searchBox.text
    readonly property var text: Settings.values.text.start
    readonly property var tuning: Settings.values.tuning
    readonly property string allView: Settings.values.startMenu.allAppsView
    readonly property int pinnedLimit: tuning.startPinnedColumns * (pinnedExpanded ? tuning.startPinnedRows : tuning.startPinnedRowsCollapsed)

    function tileMenuItems(appId: string): list<var> {
        return [
            Apps.isPinnedToStart(appId)
                ? { text: text.unpinFromStart, icon: Icons.Icon.pinOff, action: () => Apps.toggleStartPin(appId) }
                : { text: text.pinToStart, icon: Icons.Icon.pin, action: () => Apps.toggleStartPin(appId) },
            Apps.isPinnedToTaskbar(appId)
                ? { text: Settings.values.text.taskbar.unpinFromTaskbar, icon: Icons.Icon.pinOff, action: () => Apps.toggleTaskbarPin(appId) }
                : { text: Settings.values.text.taskbar.pinToTaskbar, icon: Icons.Icon.pin, action: () => Apps.toggleTaskbarPin(appId) },
        ];
    }

    function toggleCategory(category: string): void {
        const next = Object.assign({}, expandedCategories);
        next[category] = !next[category];
        expandedCategories = next;
    }

    readonly property list<var> powerItems: [
        { text: Settings.values.text.session.lock, icon: Icons.Icon.lockClosed, action: () => { ShellState.close(); Session.lock(); } },
        { text: Settings.values.text.session.signOut, icon: Icons.Icon.signOut, action: () => { ShellState.close(); Session.signOut(); } },
        { text: Settings.values.text.session.sleep, icon: Icons.Icon.weatherMoon, action: () => { ShellState.close(); Session.suspend(); } },
        { text: Settings.values.text.session.shutDown, icon: Icons.Icon.power, action: () => { ShellState.close(); Session.powerOff(); } },
        { text: Settings.values.text.session.restart, icon: Icons.Icon.arrowClockwise, action: () => { ShellState.close(); Session.restart(); } },
    ]

    Component.onCompleted: if (payload && payload.allApps === true) Qt.callLater(() => scroller.contentY = allHeader.y)

    component SectionHeader: RowLayout {
        id: header

        required property string title
        property string actionText: ""
        property var actionIcon: null

        signal action

        Layout.fillWidth: true
        Layout.topMargin: Theme.spacing.small

        Label { text: header.title; variant: UiEnums.TextVariant.BodyStrong; Layout.fillWidth: true }

        Button {
            visible: header.actionText !== ""
            text: header.actionText
            icon: header.actionIcon
            variant: UiEnums.ButtonVariant.Subtle
            onActivated: header.action()
        }
    }

    StartPanelPlacement {
        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            SearchBox {
                id: searchBox
                Layout.fillWidth: true
                Layout.margins: Theme.spacing.xLarge
                Layout.bottomMargin: Theme.spacing.medium
                focus: true
                placeholder: root.text.searchPlaceholder
                onAccepted: results.launchSelected()
                onNavigateDown: results.moveSelection(1)
                onNavigateUp: results.moveSelection(-1)
            }

            SearchResultsView {
                id: results
                visible: root.query !== ""
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: Theme.spacing.xxLarge
                Layout.rightMargin: Theme.spacing.xxLarge
                query: root.query
            }

            Flickable {
                id: scroller
                visible: root.query === ""
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentHeight: sections.implicitHeight + Theme.spacing.large
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Behavior on contentY {
                    NumberAnimation { duration: Theme.motion.enter; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.emphasized }
                }

                ColumnLayout {
                    id: sections
                    x: Theme.spacing.xxLarge
                    width: scroller.width - Theme.spacing.xxLarge * 2
                    spacing: Theme.spacing.small

                    SectionHeader {
                        title: root.text.pinned
                        actionText: Apps.startPinned.length > root.tuning.startPinnedColumns * root.tuning.startPinnedRowsCollapsed ? (root.pinnedExpanded ? root.text.showLess : root.text.showAll) : ""
                        actionIcon: root.pinnedExpanded ? Icons.Icon.chevronUp : Icons.Icon.chevronDown
                        onAction: root.pinnedExpanded = !root.pinnedExpanded
                    }

                    GridLayout {
                        columns: root.tuning.startPinnedColumns
                        columnSpacing: 0
                        rowSpacing: 0

                        Repeater {
                            model: Apps.startPinned.slice(0, root.pinnedLimit)

                            AppTile {
                                required property string modelData
                                required property int index
                                appId: modelData
                                appearIndex: index
                                onMenuRequested: (appId) => root.menuAppId = appId
                            }
                        }
                    }

                    ColumnLayout {
                        visible: Settings.values.startMenu.showRecommended
                        Layout.fillWidth: true
                        spacing: Theme.spacing.small

                        SectionHeader { title: root.text.recommended }

                        Label {
                            visible: RecentFiles.files.length === 0
                            text: root.text.noRecommended
                            tone: UiEnums.TextTone.Secondary
                        }

                        GridLayout {
                            Layout.fillWidth: true
                            columns: root.tuning.startRecommendedColumns
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

                    RowLayout {
                        id: allHeader
                        Layout.fillWidth: true
                        Layout.topMargin: Theme.spacing.medium

                        Label { text: root.text.all; variant: UiEnums.TextVariant.BodyStrong; Layout.fillWidth: true }

                        Repeater {
                            model: [
                                { view: Enums.AllAppsView.Category, label: root.text.viewCategory },
                                { view: Enums.AllAppsView.Grid, label: root.text.viewGrid },
                                { view: Enums.AllAppsView.List, label: root.text.viewList },
                            ]

                            Button {
                                required property var modelData
                                text: modelData.label
                                variant: UiEnums.ButtonVariant.Subtle
                                checked: root.allView === modelData.view
                                onActivated: Settings.update(Schema.SettingKey.StartAllAppsView, modelData.view)
                            }
                        }
                    }

                    ColumnLayout {
                        visible: root.allView === Enums.AllAppsView.Category
                        Layout.fillWidth: true
                        spacing: Theme.spacing.medium

                        Repeater {
                            model: Apps.categorized

                            Card {
                                id: categoryCard

                                required property var modelData
                                readonly property bool expanded: root.expandedCategories[modelData.category] === true
                                readonly property int hidden: Math.max(0, modelData.apps.length - root.tuning.startCategoryPreview)

                                Layout.fillWidth: true
                                implicitHeight: categoryColumn.implicitHeight + Theme.spacing.medium * 2

                                ColumnLayout {
                                    id: categoryColumn
                                    anchors.fill: parent
                                    anchors.margins: Theme.spacing.medium
                                    spacing: Theme.spacing.xSmall

                                    RowLayout {
                                        Layout.fillWidth: true
                                        Label {
                                            Layout.fillWidth: true
                                            text: Settings.values.text.appCategories[categoryCard.modelData.category] ?? categoryCard.modelData.category
                                            variant: UiEnums.TextVariant.Caption
                                            tone: UiEnums.TextTone.Secondary
                                        }
                                        Button {
                                            visible: categoryCard.hidden > 0
                                            variant: UiEnums.ButtonVariant.Subtle
                                            text: categoryCard.expanded ? root.text.showLess : `+${categoryCard.hidden} ${root.text.more}`
                                            onActivated: root.toggleCategory(categoryCard.modelData.category)
                                        }
                                    }

                                    Flow {
                                        Layout.fillWidth: true
                                        spacing: 0

                                        Repeater {
                                            model: categoryCard.expanded ? categoryCard.modelData.apps : categoryCard.modelData.apps.slice(0, root.tuning.startCategoryPreview)

                                            AppTile {
                                                required property var modelData
                                                appId: modelData.id
                                                onMenuRequested: (appId) => root.menuAppId = appId
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Flow {
                        visible: root.allView === Enums.AllAppsView.Grid
                        Layout.fillWidth: true
                        spacing: 0

                        Repeater {
                            model: root.allView === Enums.AllAppsView.Grid ? Apps.visibleEntries : []

                            AppTile {
                                required property var modelData
                                required property int index
                                appId: modelData.id
                                appearIndex: index
                                onMenuRequested: (appId) => root.menuAppId = appId
                            }
                        }
                    }

                    ColumnLayout {
                        visible: root.allView === Enums.AllAppsView.List
                        Layout.fillWidth: true
                        spacing: Theme.spacing.xxSmall

                        Repeater {
                            model: root.allView === Enums.AllAppsView.List ? Apps.visibleEntries : []

                            ListItem {
                                required property var modelData
                                Layout.fillWidth: true
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
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.size.startFooterHeight
                color: Theme.colors.cardBackgroundSecondary

                Divider { anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.spacing.xxxLarge
                    anchors.rightMargin: Theme.spacing.xxxLarge
                    spacing: Theme.spacing.medium

                    Avatar { source: UserAccount.avatarSource; initial: UserAccount.initial }
                    Label { text: UserAccount.name; Layout.fillWidth: true }

                    IconButton {
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
