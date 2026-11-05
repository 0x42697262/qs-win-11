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
import "../../../domain/catalog/appearance.mjs" as AppearanceCatalog

FloatingWindow {
    id: root

    readonly property var text: Settings.values.text.settingsApp
    readonly property string aboutSection: Strings.SETTINGS_ABOUT_SECTION
    readonly property list<string> sections: Presentation.sectionsOf(Schema.SETTING_DEFINITIONS).concat([aboutSection])
    property bool changedOnly: false
    readonly property bool showingAbout: SettingsWindow.section === aboutSection && search.text === "" && !changedOnly
    readonly property list<var> shown: Presentation.visibleDefinitions(Schema.SETTING_DEFINITIONS, SettingsWindow.section, search.text, changedOnly ? Settings.overrides : null)

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
                placeholder: root.text.search
                Component.onCompleted: text = SettingsWindow.query

                Connections {
                    target: SettingsWindow
                    function onQueryChanged(): void {
                        search.text = SettingsWindow.query;
                    }
                }
            }

            Button {
                Layout.fillWidth: true
                Layout.bottomMargin: Theme.spacing.medium
                text: root.text.changedOnly
                checked: root.changedOnly
                onActivated: root.changedOnly = !root.changedOnly
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
                    visible: Settings.unbounded
                    Layout.fillWidth: true
                    severity: UiEnums.InfoSeverity.Error
                    title: root.text.unboundedTitle
                    message: root.text.unboundedBody
                }

                InfoBar {
                    visible: Settings.problems.length > 0
                    Layout.fillWidth: true
                    severity: UiEnums.InfoSeverity.Warning
                    title: Settings.values.text.settingsProblems.title
                    message: `${Settings.values.text.settingsProblems.body} ${Settings.problems.map(problem => problem.key).join(", ")}`
                }

                ProfilesPanel {
                    visible: SettingsWindow.section === Schema.SettingsSection.Profiles && search.text === "" && !root.changedOnly
                    Layout.fillWidth: true
                    Layout.bottomMargin: Theme.spacing.large
                }

                EffectsPanel {
                    visible: SettingsWindow.section === AppearanceCatalog.APPEARANCE_SECTION_NAME && search.text === "" && !root.changedOnly
                    Layout.fillWidth: true
                    Layout.bottomMargin: Theme.spacing.large
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

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: Theme.spacing.large
                        spacing: Theme.spacing.small

                        SearchBox {
                            id: profilePath
                            Layout.fillWidth: true
                            icon: null
                            placeholder: root.text.profilePlaceholder
                            text: Profiles.lastPath
                        }

                        Button {
                            text: root.text.exportProfile
                            onActivated: Profiles.exportTo(profilePath.text, "")
                        }

                        Button {
                            text: root.text.importProfile
                            variant: UiEnums.ButtonVariant.Accent
                            onActivated: Profiles.importFrom(profilePath.text)
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
