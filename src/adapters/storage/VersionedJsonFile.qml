import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.services
import "../../domain/settings/document.mjs" as Document
import "../../domain/catalog/logEvents.mjs" as LogEvents
import "../../domain/catalog/units.mjs" as Units
import "../../domain/catalog/system.mjs" as SystemCatalog
import "../../domain/settings/validation.mjs" as Validation

Scope {
    id: root

    required property string path
    required property var schema
    required property string invalidEvent

    readonly property var resolved: Document.resolveDocument(file.loadedText, schema)
    readonly property var values: resolved.values
    readonly property var problems: resolved.problems
    readonly property var overrides: pendingOverrides ?? resolved.overrides
    readonly property bool loaded: file.loadedOnce
    property var pendingOverrides: null

    function update(key: string, value: var): bool {
        const base = pendingOverrides ?? resolved.overrides;
        const result = Document.applyOverride(base, key, value, schema);
        if (!result.accepted) {
            Log.warning(LogEvents.LogEvent.SettingsWriteRejected, { path, key, problem: result.problem });
            return false;
        }
        pendingOverrides = result.overrides;
        writeDebounce.restart();
        return true;
    }

    function mergeOverrides(incoming: var): void {
        pendingOverrides = Object.assign({}, overrides, incoming);
        writeDebounce.restart();
    }

    function replaceAll(text: string): var {
        const incoming = Document.resolveDocument(text, schema);
        pendingOverrides = incoming.overrides;
        writeDebounce.restart();
        return incoming.problems;
    }

    function serialized(): string {
        return Document.serializeDocument(overrides, schema);
    }

    function flush(): void {
        if (pendingOverrides === null) {
            return;
        }
        const unreadable = resolved.problems.some(problem => problem.problem === Validation.ValidationProblem.UnreadableDocument);
        if (unreadable) {
            Log.error(LogEvents.LogEvent.SettingsWriteFailed, { path, reason: Validation.ValidationProblem.UnreadableDocument });
            pendingOverrides = null;
            return;
        }
        ensureDirectory.textToWrite = Document.serializeDocument(pendingOverrides, schema);
        pendingOverrides = null;
        ensureDirectory.running = true;
    }

    onProblemsChanged: {
        problems.forEach(problem => Log.warning(invalidEvent, { path, key: problem.key, problem: problem.problem, value: problem.value }));
    }

    Timer {
        id: writeDebounce
        interval: Units.SETTINGS_WRITE_DEBOUNCE_MS
        onTriggered: root.flush()
    }

    Process {
        id: ensureDirectory

        property string textToWrite: ""

        command: [SystemCatalog.SystemBinary.MakeDirectory, "-p", root.path.substring(0, root.path.lastIndexOf("/"))]
        onExited: (exitCode) => {
            if (exitCode === 0) {
                file.writtenText = textToWrite;
                file.setText(textToWrite);
            } else {
                Log.error(LogEvents.LogEvent.SettingsWriteFailed, { path: root.path, exitCode });
            }
        }
    }

    FileView {
        id: file

        property string loadedText: ""
        property string writtenText: ""
        property bool loadedOnce: false

        path: root.path
        watchChanges: true
        atomicWrites: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: {
            loadedText = text();
            loadedOnce = true;
        }
        onLoadFailed: {
            loadedText = "";
            loadedOnce = true;
        }
        onSaved: {
            loadedText = writtenText;
            reload();
        }
        onSaveFailed: (error) => Log.error(LogEvents.LogEvent.SettingsWriteFailed, { path: root.path, error: FileViewError.toString(error) })
    }
}
