pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.config
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/settings/definitions.mjs" as Definitions
import "../../../domain/settings/presentation.mjs" as Presentation
import "../../../domain/settings/document.mjs" as Document
import "../../../domain/numbers.mjs" as Numbers

Loader {
    id: root

    required property var definition
    readonly property var value: Document.flattenValues(Object.assign({}, Settings.values))[definition.key]
    readonly property var type: Definitions.SettingType

    function commit(newValue: var): void {
        Settings.update(definition.key, newValue);
    }

    sourceComponent: {
        switch (definition.type) {
        case type.Boolean:
            return booleanControl;
        case type.Enum:
            return enumControl;
        case type.Integer:
        case type.Number:
            return numberControl;
        case type.TextList:
            return definition.options ? optionListControl : textControl;
        default:
            return textControl;
        }
    }

    Component {
        id: booleanControl
        ToggleSwitch {
            checked: root.value === true
            onToggled: (checked) => root.commit(checked)
        }
    }

    Component {
        id: enumControl
        RowLayout {
            spacing: Theme.spacing.xSmall
            Repeater {
                model: root.definition.options
                Button {
                    required property string modelData
                    text: Presentation.humanize(modelData)
                    checked: root.value === modelData
                    onActivated: root.commit(modelData)
                }
            }
        }
    }

    Component {
        id: numberControl
        RowLayout {
            spacing: Theme.spacing.medium
            readonly property real span: root.definition.maximum - root.definition.minimum

            Slider {
                Layout.preferredWidth: Theme.size.settingsControl
                value: (root.value - root.definition.minimum) / parent.span
                step: root.definition.type === root.type.Integer ? 1 / parent.span : 0
                onMoved: (fraction) => {
                    const raw = root.definition.minimum + fraction * parent.span;
                    root.commit(root.definition.type === root.type.Integer ? Math.round(raw) : Numbers.roundToStep(raw, Settings.values.tuning.settingsNumberStep));
                }
            }

            Label {
                text: String(root.value)
            }
        }
    }

    Component {
        id: optionListControl
        Flow {
            width: Theme.size.settingsControl
            spacing: Theme.spacing.xSmall
            Repeater {
                model: root.definition.options
                Button {
                    required property string modelData
                    text: Presentation.humanize(modelData)
                    checked: root.value.indexOf(modelData) >= 0
                    onActivated: root.commit(checked ? root.value.filter(item => item !== modelData) : root.value.concat([modelData]))
                }
            }
        }
    }

    Component {
        id: textControl
        RowLayout {
            spacing: Theme.spacing.small

            Rectangle {
                visible: root.definition.type === root.type.Color
                implicitWidth: Theme.size.swatch
                implicitHeight: Theme.size.swatch
                radius: Theme.radius.control
                color: root.value
                border.width: Theme.size.stroke
                border.color: Theme.colors.controlStroke
            }

            SearchBox {
                id: field
                Layout.preferredWidth: Theme.size.settingsTextField
                icon: null
                text: Array.isArray(root.value) || typeof root.value === "object" ? Array.prototype.join.call(root.value, ", ") : String(root.value)
                onAccepted: root.commit(root.definition.type === root.type.TextList ? Presentation.parseListText(text) : text)
            }

            Button {
                text: Settings.values.text.settingsApp.apply
                onActivated: field.accepted()
            }
        }
    }
}
