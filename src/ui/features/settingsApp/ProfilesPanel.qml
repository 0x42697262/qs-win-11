pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/settings/presentation.mjs" as Presentation
import "../../../domain/catalog/settingsSchema.mjs" as Schema
import "../../../domain/catalog/system.mjs" as SystemCatalog
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

ColumnLayout {
    id: root

    readonly property var text: Settings.values.text.profiles
    readonly property list<string> active: Profiles.listOf(SystemCatalog.ProfileSettingKey.active)
    property list<string> chosenSections: []

    spacing: Theme.spacing.small

    Label {
        visible: ProfileLayers.installed.length === 0
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
        text: root.text.empty
        tone: UiEnums.TextTone.Secondary
    }

    Repeater {
        model: ProfileLayers.installed

        Card {
            id: profileCard

            required property string modelData
            readonly property var profile: ProfileLayers.profileState(modelData, Settings.userOverrides)
            readonly property bool isActive: root.active.indexOf(modelData) >= 0

            Layout.fillWidth: true
            implicitHeight: profileColumn.implicitHeight + Theme.spacing.large * 2

            ColumnLayout {
                id: profileColumn
                anchors.fill: parent
                anchors.margins: Theme.spacing.large
                spacing: Theme.spacing.small

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing.small

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Label { text: profileCard.modelData; variant: UiEnums.TextVariant.BodyStrong }
                        Label {
                            Layout.fillWidth: true
                            visible: text !== ""
                            text: profileCard.profile.meta.description
                            wrapMode: Text.WordWrap
                            variant: UiEnums.TextVariant.Caption
                            tone: UiEnums.TextTone.Secondary
                        }
                        Label {
                            text: `${root.text.appliesWhen}: ${profileCard.profile.meta.activateWhen ? JSON.stringify(profileCard.profile.meta.activateWhen) : root.text.always}`
                            variant: UiEnums.TextVariant.Caption
                            tone: UiEnums.TextTone.Tertiary
                        }
                    }

                    IconButton { visible: profileCard.isActive; icon: Icons.Icon.chevronDown; onActivated: Profiles.move(profileCard.modelData, -1) }
                    IconButton { visible: profileCard.isActive; icon: Icons.Icon.chevronUp; onActivated: Profiles.move(profileCard.modelData, 1) }
                    Button { text: root.text.absorb; onActivated: Profiles.absorb(profileCard.modelData) }
                    ToggleSwitch {
                        checked: profileCard.isActive
                        onToggled: (checked) => checked ? Profiles.activate(profileCard.modelData) : Profiles.deactivate(profileCard.modelData)
                    }
                }

                InfoBar {
                    visible: profileCard.profile.setsCommands
                    Layout.fillWidth: true
                    severity: profileCard.profile.trusted ? UiEnums.InfoSeverity.Informational : UiEnums.InfoSeverity.Warning
                    title: profileCard.profile.trusted ? root.text.untrust : root.text.trust
                    message: root.text.trustWarning
                }

                Button {
                    visible: profileCard.profile.setsCommands
                    text: profileCard.profile.trusted ? root.text.untrust : root.text.trust
                    variant: profileCard.profile.trusted ? UiEnums.ButtonVariant.Standard : UiEnums.ButtonVariant.Accent
                    onActivated: Profiles.setTrusted(profileCard.modelData, !profileCard.profile.trusted)
                }

                Label {
                    visible: profileCard.profile.problems.length > 0
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: `${root.text.skipped}: ${profileCard.profile.problems.map(problem => problem.key).join(", ")}`
                    variant: UiEnums.TextVariant.Caption
                    tone: UiEnums.TextTone.Critical
                }
            }
        }
    }

    Card {
        Layout.fillWidth: true
        Layout.topMargin: Theme.spacing.medium
        implicitHeight: createColumn.implicitHeight + Theme.spacing.large * 2

        ColumnLayout {
            id: createColumn
            anchors.fill: parent
            anchors.margins: Theme.spacing.large
            spacing: Theme.spacing.small

            Label { text: root.text.createTitle; variant: UiEnums.TextVariant.BodyStrong }

            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacing.xSmall

                Repeater {
                    model: Presentation.sectionsOf(Schema.SETTING_DEFINITIONS).filter(section => section !== Schema.SettingsSection.Profiles)

                    Button {
                        required property string modelData
                        text: Presentation.humanize(modelData)
                        checked: root.chosenSections.indexOf(modelData) >= 0
                        onActivated: root.chosenSections = checked ? root.chosenSections.filter(section => section !== modelData) : root.chosenSections.concat([modelData])
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                SearchBox { id: profileName; Layout.fillWidth: true; icon: null; placeholder: root.text.namePlaceholder }
                Button {
                    text: root.text.create
                    variant: UiEnums.ButtonVariant.Accent
                    enabledState: profileName.text !== "" && root.chosenSections.length > 0
                    onActivated: Profiles.create(profileName.text, root.chosenSections)
                }
            }
        }
    }
}
