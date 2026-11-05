pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.src.config
import qs.src.services
import qs.src.adapters.compositor
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/settings/presentation.mjs" as Presentation
import "../../../domain/catalog/settingsSchema.mjs" as Schema
import "../../../domain/catalog/ipcCatalog.mjs" as IpcCatalog
import "../../../domain/catalog/strings.mjs" as Strings
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/icons.mjs" as Icons

FloatingWindow {
    id: root

    readonly property var text: Strings.Strings.settingsApp
    readonly property string aboutSection: Strings.SETTINGS_ABOUT_SECTION
    readonly property list<string> sections: Presentation.sectionsOf(Schema.SETTING_DEFINITIONS).concat([aboutSection])
    readonly property bool showingAbout: SettingsWindow.section === aboutSection && search.text === ""
    readonly property list<var> shown: Presentation.visibleDefinitions(Schema.SETTING_DEFINITIONS, SettingsWindow.section, search.text)

    title: text.title
    implicitWidth: Theme.size.settingsWindowWidth
    implicitHeight: Theme.size.settingsWindowHeight
    color: Theme.colors.micaBase
    visible: SettingsWindow.open
    onVisibleChanged: if (!visible) SettingsWindow.open = false

    RowLayout {
        anchors.fill: parent
        spacing: 0

        ColumnLayout {
            Layout.preferredWidth: Theme.size.settingsSidebar
            Layout.maximumWidth: Theme.size.settingsSidebar
            Layout.fillWidth: false
            Layout.fillHeight: true
            Layout.margins: Theme.spacing.large
            spacing: Theme.spacing.xxSmall

            RowLayout {
                spacing: Theme.spacing.medium
                Layout.bottomMargin: Theme.spacing.medium
                Avatar { source: UserAccount.avatarSource; initial: UserAccount.initial }
                Label { text: UserAccount.name; variant: UiEnums.TextVariant.BodyStrong }
            }

            SearchBox {
                id: search
                Layout.fillWidth: true
                Layout.bottomMargin: Theme.spacing.medium
                placeholder: root.text.search
            }

            Repeater {
                model: root.sections

                ListItem {
                    required property string modelData
                    Layout.fillWidth: true
                    title: Presentation.humanize(modelData)
                    selected: SettingsWindow.section === modelData && search.text === ""
                    onActivated: {
                        search.text = "";
                        SettingsWindow.section = modelData;
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: page.implicitHeight + Theme.spacing.xxLarge * 2
            clip: true

            ColumnLayout {
                id: page
                x: Theme.spacing.xxLarge
                y: Theme.spacing.xxLarge
                width: parent.width - Theme.spacing.xxLarge * 2
                spacing: Theme.spacing.small

                Label {
                    text: search.text !== "" ? root.text.search : Presentation.humanize(SettingsWindow.section)
                    variant: UiEnums.TextVariant.Title
                    Layout.bottomMargin: Theme.spacing.medium
                }

                InfoBar {
                    visible: Settings.problems.length > 0
                    Layout.fillWidth: true
                    severity: UiEnums.InfoSeverity.Warning
                    title: Strings.Strings.settingsProblems.title
                    message: `${Strings.Strings.settingsProblems.body} ${Settings.problems.map(problem => problem.key).join(", ")}`
                }

                Label {
                    visible: !root.showingAbout && root.shown.length === 0
                    text: root.text.noResults
                    tone: UiEnums.TextTone.Secondary
                }

                Repeater {
                    model: root.showingAbout ? [] : root.shown
                    SettingRow {}
                }

                ColumnLayout {
                    visible: root.showingAbout
                    Layout.fillWidth: true
                    spacing: Theme.spacing.small

                    Repeater {
                        model: [
                            { label: root.text.version, value: IpcCatalog.SHELL_VERSION },
                            { label: root.text.compositor, value: Presentation.humanize(Compositor.kind) },
                            { label: root.text.settingsFile, value: Paths.settingsFile },
                        ]

                        ListItem {
                            required property var modelData
                            Layout.fillWidth: true
                            title: modelData.label
                            subtitle: modelData.value
                        }
                    }

                    Label {
                        text: root.text.features
                        variant: UiEnums.TextVariant.BodyStrong
                        Layout.topMargin: Theme.spacing.large
                    }

                    Repeater {
                        model: Object.keys(Features.enabled)

                        ListItem {
                            required property string modelData
                            readonly property var off: Features.resolved.offReasons[modelData]
                            Layout.fillWidth: true
                            icon: Features.enabled[modelData] ? Icons.Icon.checkmark : Icons.Icon.dismiss
                            title: Presentation.humanize(modelData)
                            subtitle: off ? `${root.text.reasons[off.reason]}${off.detail !== "" ? Strings.DETAIL_SEPARATOR + off.detail : ""}` : root.text.featureOn
                        }
                    }
                }
            }
        }
    }
}
