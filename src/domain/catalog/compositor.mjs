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
    ShowDesktop: "showDesktop",
});

export const REFRESH_TOPLEVEL_EVENTS = Object.freeze([HyprlandEventName.OpenWindow, HyprlandEventName.MoveWindow, HyprlandEventName.WindowTitle]);

export const LayerNamespace = Object.freeze({
    Taskbar: "qs-win-11-taskbar",
    Flyout: "qs-win-11-flyout",
    Toast: "qs-win-11-toast",
    Osd: "qs-win-11-osd",
    Overlay: "qs-win-11-overlay",
    Gallery: "qs-win-11-gallery",
});
