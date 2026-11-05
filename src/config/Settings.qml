pragma Singleton
import QtQuick
import Quickshell
import qs.src.adapters.storage
import qs.src.services
import "../domain/catalog/schemas.mjs" as Schemas
import "../domain/catalog/logEvents.mjs" as LogEvents
import "../domain/catalog/settingsSchema.mjs" as Schema
import "../domain/settings/document.mjs" as Document

Singleton {
    readonly property var userOverrides: store.overrides
    readonly property var layered: ProfileLayers.merge(userOverrides)
    readonly property var values: Document.buildValues(Schemas.SETTINGS_DOCUMENT_SCHEMA, layered.merged)
    readonly property var sources: layered.sources
    readonly property var problems: store.problems
    readonly property var overrides: userOverrides
    readonly property bool loaded: store.loaded
    readonly property bool unbounded: values.experimental.unboundedValues

    function update(key: string, value: var): bool {
        return store.update(key, value);
    }

    function isOverridden(key: string): bool {
        return key in userOverrides;
    }

    function reset(key: string): bool {
        const definition = Schema.SETTING_DEFINITIONS.find(candidate => candidate.key === key);
        return definition ? store.update(key, definition.defaultValue) : false;
    }

    function replaceAll(text: string): var {
        return store.replaceAll(text);
    }

    function mergeOverrides(incoming: var): void {
        store.mergeOverrides(incoming);
    }

    function exportText(): string {
        return store.serialized();
    }

    VersionedJsonFile {
        id: store
        path: Paths.settingsFile
        schema: Schemas.SETTINGS_DOCUMENT_SCHEMA
        invalidEvent: LogEvents.LogEvent.SettingsInvalid
    }
}
