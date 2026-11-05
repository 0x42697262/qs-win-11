pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/catalog/logEvents.mjs" as LogEvents
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/profiles.mjs" as ProfileCatalog
import "../domain/catalog/schemas.mjs" as Schemas
import "../domain/profiles/layers.mjs" as LayerRules
import "../domain/settings/document.mjs" as Document

Singleton {
    id: root

    property string lastPath: ""
    property string pendingText: ""

    function listOf(key: string): list<string> {
        const value = Settings.userOverrides[key];
        return value ? Array.prototype.slice.call(value) : [];
    }

    function activate(name: string): bool {
        const active = listOf(SystemCatalog.ProfileSettingKey.active).filter(candidate => candidate !== name);
        return Settings.update(SystemCatalog.ProfileSettingKey.active, active.concat([name]));
    }

    function deactivate(name: string): bool {
        return Settings.update(SystemCatalog.ProfileSettingKey.active, listOf(SystemCatalog.ProfileSettingKey.active).filter(candidate => candidate !== name));
    }

    function move(name: string, step: int): bool {
        const active = listOf(SystemCatalog.ProfileSettingKey.active);
        const index = active.indexOf(name);
        const target = index + step;
        if (index < 0 || target < 0 || target >= active.length) {
            return false;
        }
        active.splice(index, 1);
        active.splice(target, 0, name);
        return Settings.update(SystemCatalog.ProfileSettingKey.active, active);
    }

    function order(names: list<string>): bool {
        return Settings.update(SystemCatalog.ProfileSettingKey.active, names);
    }

    function setTrusted(name: string, trusted: bool): bool {
        const list = listOf(SystemCatalog.ProfileSettingKey.trustedCommands).filter(candidate => candidate !== name);
        return Settings.update(SystemCatalog.ProfileSettingKey.trustedCommands, trusted ? list.concat([name]) : list);
    }

    function create(name: string, sections: list<string>): bool {
        if (name === "" || name.indexOf(ProfileCatalog.PATH_SEPARATOR) >= 0) {
            return false;
        }
        const picked = LayerRules.overridesForSections(Settings.userOverrides, sections);
        pendingText = Document.serializeDocument(picked, Schemas.SETTINGS_DOCUMENT_SCHEMA);
        lastPath = `${Paths.profilesDirectory}${ProfileCatalog.PATH_SEPARATOR}${name}${ProfileCatalog.PATH_SEPARATOR}${ProfileCatalog.PROFILE_FILE}`;
        makeDirectory.command = [SystemCatalog.SystemBinary.MakeDirectory, "-p", `${Paths.profilesDirectory}${ProfileCatalog.PATH_SEPARATOR}${name}`];
        makeDirectory.running = true;
        return true;
    }

    function absorb(name: string): bool {
        const state = ProfileLayers.profileState(name, Settings.userOverrides);
        if (!(name in ProfileLayers.texts)) {
            return false;
        }
        Settings.mergeOverrides(state.overrides);
        Log.info(LogEvents.LogEvent.ProfileAbsorbed, { name, keys: Object.keys(state.overrides).length });
        return true;
    }

    function exportTo(path: string, content: string): bool {
        if (path === "") {
            return false;
        }
        lastPath = path;
        exporter.path = path;
        exporter.setText(content !== "" ? content : Settings.exportText());
        return true;
    }

    function importFrom(path: string): bool {
        if (path === "") {
            return false;
        }
        lastPath = path;
        importer.path = "";
        importer.path = path;
        importer.reload();
        return true;
    }

    Process {
        id: makeDirectory
        onExited: (exitCode) => {
            if (exitCode === 0) {
                root.exportTo(root.lastPath, root.pendingText);
                Log.info(LogEvents.LogEvent.ProfileCreated, { path: root.lastPath });
                ProfileLayers.rescan();
            } else {
                Log.warning(LogEvents.LogEvent.ProfileFailed, { path: root.lastPath, exitCode });
            }
        }
    }

    FileView {
        id: exporter
        printErrors: false
        onSaved: Log.info(LogEvents.LogEvent.ProfileExported, { path: root.lastPath })
        onSaveFailed: (error) => Log.warning(LogEvents.LogEvent.ProfileFailed, { path: root.lastPath, error: FileViewError.toString(error) })
    }

    FileView {
        id: importer
        printErrors: false
        onLoaded: {
            const problems = Settings.replaceAll(text());
            Log.info(LogEvents.LogEvent.ProfileImported, { path: root.lastPath, skipped: problems.map(problem => problem.key) });
        }
        onLoadFailed: (error) => Log.warning(LogEvents.LogEvent.ProfileFailed, { path: root.lastPath, error: FileViewError.toString(error) })
    }
}
