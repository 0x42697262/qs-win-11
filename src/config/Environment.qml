pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property string home: Quickshell.env("HOME") ?? ""
    readonly property string configHome: Quickshell.env("XDG_CONFIG_HOME") ?? `${home}/.config`
    readonly property string dataHome: Quickshell.env("XDG_DATA_HOME") ?? `${home}/.local/share`
    readonly property string dataDirs: Quickshell.env("XDG_DATA_DIRS") ?? "/usr/local/share:/usr/share"
    readonly property string stateHome: Quickshell.env("XDG_STATE_HOME") ?? `${home}/.local/state`
    readonly property string hyprlandSignature: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") ?? ""
    readonly property string userName: Quickshell.env("USER") ?? ""
    readonly property string sessionId: Quickshell.env("XDG_SESSION_ID") ?? ""
    readonly property bool galleryRequested: (Quickshell.env("QS_WIN11_GALLERY") ?? "") !== ""
}
