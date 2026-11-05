pragma Singleton
import QtQuick
import Quickshell
import "../domain/shell/surfaces.mjs" as Surfaces

Singleton {
    id: root

    property var state: Surfaces.CLOSED
    readonly property string openSurface: state.surface
    readonly property string openScreenName: state.screenName
    readonly property var payload: state.payload

    function defaultScreenName(): string {
        const focused = Windows.focusedMonitorName;
        if (focused !== "") {
            return focused;
        }
        return Quickshell.screens.length > 0 ? Quickshell.screens[0].name : "";
    }

    function toggle(surface: string, screenName: string): void {
        toggleWith(surface, screenName, null);
    }

    function toggleWith(surface: string, screenName: string, payload: var): void {
        state = Surfaces.toggleSurface(state, surface, screenName === "" ? defaultScreenName() : screenName, payload ?? null);
    }

    function open(surface: string, screenName: string, payload: var): void {
        state = Surfaces.openSurface(surface, screenName === "" ? defaultScreenName() : screenName, payload ?? null);
    }

    function close(): void {
        state = Surfaces.CLOSED;
    }

    function isOpen(surface: string, screenName: string): bool {
        return openSurface === surface && openScreenName === screenName;
    }
}
