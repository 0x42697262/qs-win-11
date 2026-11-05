pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/enums.mjs" as Enums
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/symbols.mjs" as SymbolCatalog

FocusScope {
    id: root

    readonly property var text: Settings.values.text.panel
    readonly property string tab: ClipboardHistory.tab
    property int emojiGroup: 0
    property int symbolGroup: 0
    readonly property bool searching: search.text.trim() !== "" && (tab === Enums.PanelTab.Emoji || tab === Enums.PanelTab.Symbols)
    readonly property list<string> gridItems: {
        if (tab === Enums.PanelTab.Emoji) {
            if (searching) {
                return ClipboardHistory.searchEmoji(search.text).map(emoji => emoji.char);
            }
            const group = ClipboardHistory.emojiData[emojiGroup];
            return group ? group.emoji.map(emoji => emoji.char) : [];
        }
        if (tab === Enums.PanelTab.Symbols) {
            const group = SymbolCatalog.SYMBOL_GROUPS[symbolGroup];
            const all = group ? Array.from(group.symbols) : [];
            return searching ? SymbolCatalog.SYMBOL_GROUPS.map(candidate => Array.from(candidate.symbols)).reduce((joined, chars) => joined.concat(chars), []).filter(char => char === search.text.trim()) : all;
        }
        return [];
    }

    Component.onCompleted: {
        ClipboardHistory.loadEmoji();
        ClipboardHistory.refresh();
    }

    FlyoutPanel {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.spacing.medium
        width: Theme.size.emojiPanelWidth
        height: Theme.size.emojiPanelHeight
        clipContent: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacing.medium
            spacing: Theme.spacing.small

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.xSmall

                Repeater {
                    model: [
                        { tab: Enums.PanelTab.Emoji, icon: Icons.Icon.emoji, label: root.text.emoji, shown: Features.enabled.emojiPanel },
                        { tab: Enums.PanelTab.Kaomoji, icon: Icons.Icon.emoji, label: root.text.kaomoji, shown: Features.enabled.emojiPanel },
                        { tab: Enums.PanelTab.Symbols, icon: Icons.Icon.numberSymbol, label: root.text.symbols, shown: Features.enabled.emojiPanel },
                        { tab: Enums.PanelTab.Clipboard, icon: Icons.Icon.clipboard, label: root.text.clipboard, shown: Features.enabled.clipboardHistory },
                    ]

                    IconButton {
                        id: tabButton
                        required property var modelData
                        visible: modelData.shown
                        icon: modelData.icon
                        variant: root.tab === modelData.tab ? UiEnums.ButtonVariant.Accent : UiEnums.ButtonVariant.Subtle
                        onActivated: {
                            ClipboardHistory.tab = modelData.tab;
                            if (modelData.tab === Enums.PanelTab.Clipboard) {
                                ClipboardHistory.refresh();
                            }
                        }

                        ToolTip { target: tabButton; hovered: tabButton.hovered; text: tabButton.modelData.label }
                    }
                }

                Label {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.spacing.small
                    text: root.tab === Enums.PanelTab.Clipboard ? root.text.clipboard : root.tab === Enums.PanelTab.Kaomoji ? root.text.kaomoji : root.tab === Enums.PanelTab.Symbols ? root.text.symbols : root.text.emoji
                    variant: UiEnums.TextVariant.BodyStrong
                }

                Button {
                    visible: root.tab === Enums.PanelTab.Clipboard && ClipboardHistory.entries.length > 0
                    text: root.text.clearAll
                    onActivated: ClipboardHistory.clear()
                }
            }

            SearchBox {
                id: search
                visible: root.tab === Enums.PanelTab.Emoji || root.tab === Enums.PanelTab.Symbols
                Layout.fillWidth: true
                focus: true
                placeholder: root.text.search
                onAccepted: if (root.gridItems.length > 0) ClipboardHistory.insertText(root.gridItems[0])
            }

            Label {
                visible: root.tab === Enums.PanelTab.Emoji && !root.searching && ClipboardHistory.recentEmoji.length > 0
                text: root.text.recent
                variant: UiEnums.TextVariant.Caption
                tone: UiEnums.TextTone.Secondary
            }

            Flow {
                visible: root.tab === Enums.PanelTab.Emoji && !root.searching && ClipboardHistory.recentEmoji.length > 0
                Layout.fillWidth: true
                Layout.maximumHeight: Theme.size.emojiCell
                clip: true

                Repeater {
                    model: ClipboardHistory.recentEmoji

                    EmojiCell {
                        required property string modelData
                        glyph: modelData
                    }
                }
            }

            GridView {
                id: grid
                visible: root.tab === Enums.PanelTab.Emoji || root.tab === Enums.PanelTab.Symbols
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                cellWidth: width / Settings.values.tuning.emojiColumns
                cellHeight: Theme.size.emojiCell
                model: root.gridItems
                boundsBehavior: Flickable.StopAtBounds

                delegate: EmojiCell {
                    required property string modelData
                    width: grid.cellWidth
                    glyph: modelData
                }
            }

            Label {
                visible: root.tab === Enums.PanelTab.Emoji && root.searching && root.gridItems.length === 0
                text: root.text.noEmoji
                tone: UiEnums.TextTone.Secondary
            }

            RowLayout {
                visible: (root.tab === Enums.PanelTab.Emoji || root.tab === Enums.PanelTab.Symbols) && !root.searching
                Layout.fillWidth: true
                spacing: 0

                Repeater {
                    model: root.tab === Enums.PanelTab.Emoji ? ClipboardHistory.emojiData : SymbolCatalog.SYMBOL_GROUPS

                    Interactive {
                        id: groupButton

                        required property var modelData
                        required property int index
                        readonly property bool current: (root.tab === Enums.PanelTab.Emoji ? root.emojiGroup : root.symbolGroup) === index
                        readonly property string label: root.tab === Enums.PanelTab.Emoji ? (root.text.emojiGroups[SymbolCatalog.EMOJI_GROUP_IDS[modelData.name]] ?? modelData.name) : (root.text.symbolGroups[modelData.name] ?? modelData.name)

                        Layout.fillWidth: true
                        implicitHeight: Theme.size.emojiCell
                        onActivated: {
                            if (root.tab === Enums.PanelTab.Emoji) {
                                root.emojiGroup = index;
                            } else {
                                root.symbolGroup = index;
                            }
                            grid.positionViewAtBeginning();
                        }

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: Theme.spacing.xxSmall
                            radius: Theme.radius.control
                            color: groupButton.current ? Theme.colors.subtleFillPressed : groupButton.hovered ? Theme.colors.subtleFillHover : Theme.colors.transparent
                        }

                        Rectangle {
                            visible: groupButton.current
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            width: Theme.size.openIndicatorWidth
                            height: Theme.size.indicatorHeight
                            radius: height / 2
                            color: Theme.colors.accent
                        }

                        Label {
                            anchors.centerIn: parent
                            text: root.tab === Enums.PanelTab.Emoji ? (groupButton.modelData.emoji[0] ? groupButton.modelData.emoji[0].char : "") : Array.from(groupButton.modelData.symbols)[0]
                        }

                        ToolTip { target: groupButton; hovered: groupButton.hovered; text: groupButton.label }
                    }
                }
            }

            Flickable {
                visible: root.tab === Enums.PanelTab.Kaomoji
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentHeight: kaomoji.implicitHeight
                clip: true

                Flow {
                    id: kaomoji
                    width: parent.width
                    spacing: Theme.spacing.xSmall

                    Repeater {
                        model: SymbolCatalog.KAOMOJI

                        Button {
                            required property string modelData
                            text: modelData
                            variant: UiEnums.ButtonVariant.Subtle
                            onActivated: ClipboardHistory.insertText(modelData)
                        }
                    }
                }
            }

            Label {
                visible: root.tab === Enums.PanelTab.Clipboard && ClipboardHistory.entries.length === 0
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: root.text.emptyClipboard
                tone: UiEnums.TextTone.Secondary
            }

            ListView {
                visible: root.tab === Enums.PanelTab.Clipboard
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: Theme.spacing.xSmall
                model: ClipboardHistory.entries
                boundsBehavior: Flickable.StopAtBounds

                delegate: Card {
                    id: clipCard

                    required property var modelData
                    required property int index

                    width: ListView.view.width
                    implicitHeight: clipRow.implicitHeight + Theme.spacing.medium * 2
                    color: clipArea.containsMouse ? Theme.colors.subtleFillHover : Theme.surfaceFill

                    Appear {
                        target: clipCard
                        index: clipCard.index
                    }

                    MouseArea {
                        id: clipArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: ClipboardHistory.restore(clipCard.modelData)
                    }

                    RowLayout {
                        id: clipRow
                        anchors.fill: parent
                        anchors.margins: Theme.spacing.medium
                        spacing: Theme.spacing.small

                        FluentIcon {
                            visible: clipCard.modelData.isImage
                            glyph: Icons.Icon.image
                        }

                        Label {
                            Layout.fillWidth: true
                            text: clipCard.modelData.isImage ? root.text.image : clipCard.modelData.preview
                            maximumLineCount: Settings.values.tuning.clipboardPreviewLines
                            wrapMode: Text.Wrap
                            elide: Text.ElideRight
                        }

                        IconButton {
                            icon: Icons.Icon.delete
                            onActivated: ClipboardHistory.remove(clipCard.modelData)
                        }
                    }
                }
            }
        }
    }

    Keys.onEscapePressed: ShellState.close()
}
