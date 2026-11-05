pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/profiles/layers.mjs" as LayerRules
import "../domain/settings/document.mjs" as Document
import "../domain/theme/themeMode.mjs" as ThemeModeRules
import "../domain/catalog/schemas.mjs" as Schemas
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/units.mjs" as Units
import "../domain/catalog/logEvents.mjs" as LogEvents
import "../domain/catalog/profiles.mjs" as ProfileCatalog

Singleton {
    id: root

    property var texts: ({})
    property var folders: ({})
    readonly property list<string> installed: Object.keys(texts).sort()
    property list<string> discovered: []
    readonly property bool onBattery: Power.hasBattery && Power.onBattery
    readonly property int minutesNow: clock.hours * Units.MINUTES_PER_HOUR + clock.minutes

    function userList(userOverrides: var, key: string): list<string> {
        const value = userOverrides[key];
        return value ? Array.prototype.slice.call(value) : [];
    }

    function profileState(name: string, userOverrides: var): var {
        const text = texts[name] ?? "";
        const resolved = Document.resolveDocument(text, Schemas.SETTINGS_DOCUMENT_SCHEMA);
        const trusted = userList(userOverrides, SystemCatalog.ProfileSettingKey.trustedCommands).indexOf(name) >= 0;
        const filtered = LayerRules.filterProfileOverrides(LayerRules.resolveProfilePaths(resolved.overrides, folders[name] ?? ""), trusted);
        return {
            name,
            meta: LayerRules.parseProfileMeta(text),
            overrides: filtered.overrides,
            problems: resolved.problems.concat(filtered.problems),
            trusted,
            setsCommands: filtered.problems.some(problem => problem.problem === ProfileCatalog.ProfileProblem.CommandsNotTrusted) || Object.keys(filtered.overrides).some(key => key.indexOf(ProfileCatalog.COMMAND_KEY_PREFIX) === 0),
        };
    }

    function context(userOverrides: var): var {
        const theme = Document.buildValues(Schemas.SETTINGS_DOCUMENT_SCHEMA, userOverrides).theme;
        return { onBattery, theme: ThemeModeRules.resolveThemeMode(theme.mode, minutesNow, theme.lightStartsAt, theme.darkStartsAt), minutesNow };
    }

    function gameLayers(userOverrides: var): list<var> {
        if (!ShellData.values.gameMode) {
            return [];
        }
        const name = Document.buildValues(Schemas.SETTINGS_DOCUMENT_SCHEMA, userOverrides).quickSettings.gameModeProfile;
        const overrides = name in texts ? profileState(name, userOverrides).overrides : ProfileCatalog.GAME_MODE_DEFAULT_OVERRIDES;
        return [{ name, overrides }];
    }

    function merge(userOverrides: var): var {
        const active = userList(userOverrides, SystemCatalog.ProfileSettingKey.active);
        const currentContext = context(userOverrides);
        const layers = active
            .filter(name => name in texts)
            .map(name => profileState(name, userOverrides))
            .filter(state => LayerRules.conditionsMatch(state.meta.activateWhen, currentContext))
            .map(state => ({ name: state.name, overrides: state.overrides }));
        return LayerRules.mergeLayers(layers, userOverrides, gameLayers(userOverrides));
    }

    function store(name: string, folder: string, text: string): void {
        const nextTexts = Object.assign({}, texts);
        const nextFolders = Object.assign({}, folders);
        nextTexts[name] = text;
        nextFolders[name] = folder;
        texts = nextTexts;
        folders = nextFolders;
        Log.info(LogEvents.LogEvent.ProfileLoaded, { name });
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    function rescan(): void {
        scanner.running = false;
        scanner.running = true;
    }

    Process {
        id: scanner
        command: [SystemCatalog.SystemBinary.Find, Paths.profilesDirectory, "-mindepth", "1", "-maxdepth", "1", "-type", "d", "-printf", "%f\\n"]
        stdout: StdioCollector {
            onStreamFinished: {
                const names = text.split("\n").filter(name => name !== "").sort();
                if (JSON.stringify(names) !== JSON.stringify(root.discovered)) {
                    root.discovered = names;
                }
            }
        }
    }

    Timer {
        running: true
        repeat: true
        triggeredOnStart: true
        interval: Settings.values.tuning.profilesRescanMs
        onTriggered: root.rescan()
    }

    Instantiator {
        model: root.discovered

        ProfileFile {
            onChanged: root.store(name, folder, text)
        }
    }
}
