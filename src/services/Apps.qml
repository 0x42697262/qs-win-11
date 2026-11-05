pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import "../domain/apps/appIds.mjs" as AppIds
import "../domain/apps/appIcons.mjs" as AppIconRules
import "../domain/apps/taskbarItems.mjs" as TaskbarRules
import "../domain/catalog/shellDataSchema.mjs" as ShellDataSchema
import "../domain/catalog/logEvents.mjs" as LogEvents
import "../domain/search/rankApps.mjs" as SearchRules

Singleton {
    id: root

    readonly property list<QtObject> entries: DesktopEntries.applications.values
    readonly property list<QtObject> visibleEntries: entries.filter(entry => !entry.noDisplay).sort((left, right) => left.name.localeCompare(right.name))
    readonly property list<string> taskbarPinned: installedOnly(ShellData.values.taskbarPinnedCustomized ? ShellData.values.taskbarPinnedApps : Settings.values.taskbar.initialPinned)
    readonly property list<var> searchable: visibleEntries.map(entry => ({ id: entry.id, name: entry.name, genericName: entry.genericName, keywords: entry.keywords }))
    readonly property list<var> alphabetGroups: SearchRules.alphabetGroups(visibleEntries)
    readonly property list<string> startPinned: installedOnly(ShellData.values.startPinnedCustomized ? ShellData.values.startPinnedApps : Settings.values.startMenu.initialPinned)

    function entryFor(appId: string): DesktopEntry {
        if (appId === "") {
            return null;
        }
        return DesktopEntries.byId(appId) ?? DesktopEntries.heuristicLookup(appId);
    }

    function installedOnly(appIds: list<string>): list<string> {
        return appIds.filter(appId => entryFor(appId) !== null);
    }

    function canonicalId(appId: string): string {
        const entry = entryFor(appId);
        return entry ? entry.id : appId;
    }

    function displayName(appId: string): string {
        const entry = entryFor(appId);
        return entry ? entry.name : appId;
    }

    function iconSource(appId: string): string {
        const entry = entryFor(appId);
        const override = AppIconTheme.overrides[AppIds.normalizeAppId(entry ? entry.id : appId)] ?? AppIconTheme.overrides[AppIds.normalizeAppId(appId)];
        const spec = AppIconRules.classifyIconSpec(override ?? (entry ? entry.icon : appId));
        if (spec.isFile) {
            return spec.value;
        }
        const themed = AppIconTheme.lookup(spec.value);
        return themed !== "" ? themed : Quickshell.iconPath(spec.value, true);
    }

    function launch(appId: string): void {
        const entry = entryFor(appId);
        if (entry) {
            entry.execute();
            Log.info(LogEvents.LogEvent.AppLaunched, { appId: entry.id });
        } else {
            Log.warning(LogEvents.LogEvent.AppNotFound, { appId });
        }
    }

    function search(query: string): list<var> {
        return SearchRules.rankApps(searchable, query, Settings.values.tuning.searchResultLimit, Settings.values.tuning).map(ranked => ranked.app);
    }

    function taskbarItems(windows: list<var>): list<var> {
        return TaskbarRules.buildTaskbarItems(taskbarPinned, windows, appId => canonicalId(appId));
    }

    function isPinnedToTaskbar(appId: string): bool {
        return AppIds.isPinned(taskbarPinned, canonicalId(appId));
    }

    function setTaskbarPinned(appIds: list<string>): void {
        ShellData.update(ShellDataSchema.ShellDataKey.TaskbarPinnedApps, appIds);
        ShellData.update(ShellDataSchema.ShellDataKey.TaskbarPinnedCustomized, true);
    }

    function toggleTaskbarPin(appId: string): void {
        const canonical = canonicalId(appId);
        setTaskbarPinned(isPinnedToTaskbar(canonical) ? AppIds.unpinApp(taskbarPinned, canonical) : AppIds.pinApp(taskbarPinned, canonical));
    }

    function isPinnedToStart(appId: string): bool {
        return AppIds.isPinned(startPinned, canonicalId(appId));
    }

    function toggleStartPin(appId: string): void {
        const canonical = canonicalId(appId);
        const next = isPinnedToStart(canonical) ? AppIds.unpinApp(startPinned, canonical) : AppIds.pinApp(startPinned, canonical);
        ShellData.update(ShellDataSchema.ShellDataKey.StartPinnedApps, next);
        ShellData.update(ShellDataSchema.ShellDataKey.StartPinnedCustomized, true);
    }

    function moveStartPin(appId: string, targetIndex: int): void {
        ShellData.update(ShellDataSchema.ShellDataKey.StartPinnedApps, AppIds.movePinnedApp(startPinned, canonicalId(appId), targetIndex));
        ShellData.update(ShellDataSchema.ShellDataKey.StartPinnedCustomized, true);
    }
}
