import QtQuick
import QtQuick.Layouts
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/settings/presentation.mjs" as Presentation
import "../../../domain/catalog/settingsSchema.mjs" as Schema
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/features/resolveFeatures.mjs" as FeatureRules
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/strings.mjs" as Strings

Card {
    id: root

    required property var modelData
    readonly property bool isFeature: modelData.section === Schema.SettingsSection.Features
    readonly property string featureName: isFeature ? Presentation.featureNameFromKey(modelData.key) : ""
    readonly property var offReason: isFeature ? Features.resolved.offReasons[featureName] : undefined
    readonly property bool overridden: Settings.isOverridden(modelData.key)
    readonly property bool problem: Settings.problems.some(candidate => candidate.key === modelData.key)

    Layout.fillWidth: true
    implicitHeight: row.implicitHeight + Theme.spacing.large * 2
    borderColor: problem ? Theme.colors.caution : Theme.colors.cardStroke

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.margins: Theme.spacing.large
        spacing: Theme.spacing.large

        ColumnLayout {
            Layout.fillWidth: true
            Layout.minimumWidth: Theme.size.settingsSidebar
            spacing: Theme.spacing.xxSmall

            Label {
                Layout.fillWidth: true
                text: root.isFeature ? Presentation.humanize(root.featureName) : root.modelData.label
            }

            Label {
                Layout.fillWidth: true
                text: root.modelData.description
                wrapMode: Text.WordWrap
                variant: UiEnums.TextVariant.Caption
                tone: UiEnums.TextTone.Secondary
            }

            Label {
                Layout.fillWidth: true
                visible: root.overridden
                text: `${Settings.values.text.settingsApp.defaultValue}: ${JSON.stringify(root.modelData.defaultValue)}`
                variant: UiEnums.TextVariant.Caption
                tone: UiEnums.TextTone.Tertiary
            }

            Label {
                visible: root.isFeature && root.offReason !== undefined && root.offReason.reason !== FeatureRules.FeatureOffReason.DisabledByUser
                text: root.offReason ? `${Settings.values.text.settingsApp.reasons[root.offReason.reason]}${root.offReason.detail !== "" ? Strings.DETAIL_SEPARATOR + root.offReason.detail : ""}` : ""
                variant: UiEnums.TextVariant.Caption
                tone: UiEnums.TextTone.Critical
            }
        }

        SettingControl {
            definition: root.modelData
        }

        IconButton {
            visible: root.overridden
            icon: Icons.Icon.arrowClockwise
            toolTip: Settings.values.text.settingsApp.reset
            onActivated: Settings.reset(root.modelData.key)
        }
    }
}
