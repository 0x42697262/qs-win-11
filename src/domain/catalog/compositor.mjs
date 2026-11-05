export const HyprlandEventName = Object.freeze({
    OpenWindow: "openwindow",
    MoveWindow: "movewindowv2",
    WindowTitle: "windowtitlev2",
});

export const HYPRLAND_CLASS_FIELD = "class";

export const CompositorAction = Object.freeze({
    FocusWindow: "focusWindow",
    CloseWindow: "closeWindow",
    ToggleMinimize: "toggleMinimize",
    ActivateWorkspace: "activateWorkspace",
    PlaceWindow: "placeWindow",
});

export const REFRESH_TOPLEVEL_EVENTS = Object.freeze([HyprlandEventName.OpenWindow, HyprlandEventName.MoveWindow, HyprlandEventName.WindowTitle]);
