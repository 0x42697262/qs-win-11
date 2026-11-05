pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/input/clipboard.mjs" as ClipboardRules
import "../domain/search/runHistory.mjs" as RecentRules
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/shellDataSchema.mjs" as ShellDataSchema
import "../domain/catalog/enums.mjs" as Enums

Singleton {
    id: root

    property list<var> entries: []
    property string tab: Enums.PanelTab.Emoji
    property var emojiData: ClipboardRules.emojiGroups(null)
    readonly property list<string> recentEmoji: ShellData.values.recentEmoji
    readonly property bool canType: Capabilities.hasBinary(SystemCatalog.SystemBinary.Wtype)
    property string pendingText: ""

    function refresh(): void {
        if (!Features.enabled.clipboardHistory) {
            entries = [];
            return;
        }
        lister.running = false;
        lister.running = true;
    }

    function loadEmoji(): void {
        if (emojiData.length === 0) {
            emojiFile.reload();
        }
    }

    function searchEmoji(query: string): list<var> {
        return ClipboardRules.searchEmoji(emojiData, query, Settings.values.tuning.emojiResultLimit);
    }

    function insertText(value: string): void {
        ShellData.update(ShellDataSchema.ShellDataKey.RecentEmoji, RecentRules.rememberCommand(recentEmoji, value, Settings.values.tuning.emojiRecentLimit));
        Quickshell.clipboardText = value;
        finishPick(value);
    }

    function restore(entry: var): void {
        Quickshell.execDetached([SystemCatalog.SystemBinary.Shell, "-c", SystemCatalog.CliphistCommand.decodeToClipboard, SystemCatalog.SystemBinary.Shell, entry.line]);
        finishPick(entry.isImage ? "" : entry.preview);
    }

    function remove(entry: var): void {
        remover.command = [SystemCatalog.SystemBinary.Shell, "-c", SystemCatalog.CliphistCommand.delete, SystemCatalog.SystemBinary.Shell, entry.line];
        remover.running = true;
    }

    function clear(): void {
        remover.command = Array.prototype.slice.call(SystemCatalog.CliphistCommand.wipe);
        remover.running = true;
    }

    function finishPick(value: string): void {
        ShellState.close();
        if (value !== "" && Settings.values.clipboard.typeAfterPick && canType) {
            pendingText = value;
            typeDelay.restart();
        }
    }

    FileView {
        id: emojiFile
        path: Paths.shellAsset(SystemCatalog.EMOJI_DATA_FILE)
        onLoaded: {
            try {
                root.emojiData = ClipboardRules.emojiGroups(JSON.parse(text()));
            } catch (error) {
                root.emojiData = [];
            }
        }
    }

    Timer {
        id: typeDelay
        interval: Settings.values.tuning.typeDelayMs
        onTriggered: Quickshell.execDetached([SystemCatalog.SystemBinary.Wtype, "--", root.pendingText])
    }

    Process {
        id: lister
        command: Array.prototype.slice.call(SystemCatalog.CliphistCommand.list)
        stdout: StdioCollector {
            onStreamFinished: root.entries = ClipboardRules.parseCliphistList(text, Settings.values.tuning.clipboardHistoryLimit)
        }
    }

    Process {
        id: remover
        onExited: root.refresh()
    }

    Process {
        running: Settings.values.clipboard.runWatcher && Features.enabled.clipboardHistory
        command: Array.prototype.slice.call(SystemCatalog.CliphistCommand.watch)
    }
}
