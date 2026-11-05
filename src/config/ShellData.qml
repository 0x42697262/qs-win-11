pragma Singleton
import QtQuick
import Quickshell
import qs.src.adapters.storage
import "../domain/catalog/schemas.mjs" as Schemas
import "../domain/catalog/logEvents.mjs" as LogEvents

Singleton {
    readonly property var values: store.values
    readonly property bool loaded: store.loaded

    function update(key: string, value: var): bool {
        return store.update(key, value);
    }

    VersionedJsonFile {
        id: store
        path: Paths.shellDataFile
        schema: Schemas.SHELL_DATA_DOCUMENT_SCHEMA
        invalidEvent: LogEvents.LogEvent.ShellDataInvalid
    }
}
