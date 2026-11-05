export const HyprlandEventName = Object.freeze({
    OpenWindow: "openwindow",
    MoveWindow: "movewindowv2",
    WindowTitle: "windowtitlev2",
});

export const HYPRLAND_CLASS_FIELD = "class";
export const HYPRLAND_FLOATING_FIELD = "floating";
export const HYPRLAND_RESERVED_FIELD = "reserved";

export const CompositorAction = Object.freeze({
    FocusWindow: "focusWindow",
    CloseWindow: "closeWindow",
    ToggleMinimize: "toggleMinimize",
    ActivateWorkspace: "activateWorkspace",
    PlaceWindow: "placeWindow",
    ShowDesktop: "showDesktop",
    NextKeyboardLayout: "nextKeyboardLayout",
});

export const HYPRLAND_LAYOUT_EVENT = "activelayout";

export const REFRESH_TOPLEVEL_EVENTS = Object.freeze([HyprlandEventName.OpenWindow, HyprlandEventName.MoveWindow, HyprlandEventName.WindowTitle]);

export const LayerNamespace = Object.freeze({
    Taskbar: "qs-win-11-taskbar",
    Flyout: "qs-win-11-flyout",
    Toast: "qs-win-11-toast",
    Osd: "qs-win-11-osd",
    Overlay: "qs-win-11-overlay",
    Wallpaper: "qs-win-11-wallpaper",

});

export const BLURRED_LAYER_NAMESPACES = Object.freeze([LayerNamespace.Taskbar, LayerNamespace.Flyout, LayerNamespace.Toast, LayerNamespace.Osd]);
export const BLUR_IGNORE_ALPHA = 0.3;
