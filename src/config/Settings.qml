pragma Singleton
import QtQuick
import Quickshell
import qs.src.adapters.storage
import "../domain/catalog/schemas.mjs" as Schemas
import "../domain/catalog/logEvents.mjs" as LogEvents
import "../domain/catalog/settingsSchema.mjs" as Schema

Singleton {
    readonly property var values: store.values
    readonly property var problems: store.problems
    readonly property var overrides: store.overrides
    readonly property bool unbounded: values.experimental.unboundedValues

    function isOverridden(key: string): bool {
        return key in overrides;
    }

    function reset(key: string): bool {
        const definition = Schema.SETTING_DEFINITIONS.find(candidate => candidate.key === key);
        return definition ? store.update(key, definition.defaultValue) : false;
    }
    readonly property bool loaded: store.loaded

    function update(key: string, value: var): bool {
        return store.update(key, value);
    }

    VersionedJsonFile {
        id: store
        path: Paths.settingsFile
        schema: Schemas.SETTINGS_DOCUMENT_SCHEMA
        invalidEvent: LogEvents.LogEvent.SettingsInvalid
    }
}
