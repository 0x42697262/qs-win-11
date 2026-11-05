pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/settings/presentation.mjs" as Presentation
import "../../../domain/appearance/resolveAppearance.mjs" as AppearanceRules
import "../../../domain/catalog/appearance.mjs" as AppearanceCatalog
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

ColumnLayout {
    id: root

    readonly property var text: Settings.values.text.settingsApp
    readonly property int levelCount: AppearanceCatalog.LEVEL_NAMES.length
    readonly property var levelBundle: Settings.values.appearance.levels[Appearance.resolved.levelName]

    spacing: Theme.spacing.small

    Card {
        Layout.fillWidth: true
        implicitHeight: levelColumn.implicitHeight + Theme.spacing.large * 2

        ColumnLayout {
            id: levelColumn
            anchors.fill: parent
            anchors.margins: Theme.spacing.large
            spacing: Theme.spacing.small

            RowLayout {
                Layout.fillWidth: true
                Label { text: root.text.effectsLevel; variant: UiEnums.TextVariant.BodyStrong; Layout.fillWidth: true }
                Label { text: root.text.levelNames[Settings.values.appearance.level] ?? ""; tone: UiEnums.TextTone.Accent }
            }

            Slider {
                Layout.fillWidth: true
                value: Settings.values.appearance.level / (root.levelCount - 1)
                step: 1 / (root.levelCount - 1)
                onMoved: (fraction) => Settings.update(AppearanceCatalog.LEVEL_SETTING_KEY, Math.round(fraction * (root.levelCount - 1)))
            }

            RowLayout {
                Layout.fillWidth: true
                Repeater {
                    model: root.text.levelNames
                    Label {
                        required property string modelData
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        text: modelData
                        variant: UiEnums.TextVariant.Caption
                        tone: UiEnums.TextTone.Secondary
                    }
                }
            }

            Label {
                visible: Appearance.onBattery
                text: `${root.text.effectsOnBattery} ${root.text.levelNames[Appearance.resolved.levelIndex] ?? ""}`
                variant: UiEnums.TextVariant.Caption
                tone: UiEnums.TextTone.Secondary
            }
        }
    }

    GridLayout {
        Layout.fillWidth: true
        columns: AppearanceCatalog.EFFECTS_TABLE_COLUMNS
        columnSpacing: Theme.spacing.large
        rowSpacing: Theme.spacing.xSmall

        Repeater {
            model: [root.text.effect, root.text.fromLevel, root.text.yourChoice, root.text.result, root.text.cost]
            Label {
                required property string modelData
                text: modelData
                variant: UiEnums.TextVariant.Caption
                tone: UiEnums.TextTone.Secondary
            }
        }

        Repeater {
            model: Object.keys(AppearanceCatalog.KNOBS).reduce((cells, knob) => cells.concat(AppearanceCatalog.EFFECTS_TABLE_FIELDS.map(field => ({ knob, field }))), [])

            Label {
                id: cell

                required property var modelData
                readonly property var resolvedKnob: Appearance.knobs[modelData.knob]
                readonly property string override: Settings.values.appearance.override[modelData.knob]
                readonly property bool limited: resolvedKnob.source === AppearanceRules.KnobSource.Limited

                text: {
                    switch (modelData.field) {
                    case AppearanceCatalog.EffectsTableField.Name:
                        return Presentation.humanize(modelData.knob);
                    case AppearanceCatalog.EffectsTableField.Level:
                        return Presentation.humanize(root.levelBundle[modelData.knob]);
                    case AppearanceCatalog.EffectsTableField.Choice:
                        return Presentation.humanize(override);
                    case AppearanceCatalog.EffectsTableField.Result:
                        return limited ? `${Presentation.humanize(resolvedKnob.value)} (${root.text.limitedByLevel})` : Presentation.humanize(resolvedKnob.value);
                    default:
                        return Presentation.humanize(AppearanceCatalog.KNOBS[modelData.knob].cost);
                    }
                }
                tone: modelData.field === AppearanceCatalog.EffectsTableField.Result && limited ? UiEnums.TextTone.Critical
                    : modelData.field === AppearanceCatalog.EffectsTableField.Result ? UiEnums.TextTone.Accent
                    : UiEnums.TextTone.Primary
            }
        }
    }
}
