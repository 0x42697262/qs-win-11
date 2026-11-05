export const SystemBinary = Object.freeze({
    NotifySend: "notify-send",
    Gsettings: "gsettings",
    MakeDirectory: "mkdir",
    Systemctl: "systemctl",
    Loginctl: "loginctl",
    Shell: "sh",
});

export const SystemPath = Object.freeze({
    OwnProcessStat: "/proc/self/stat",
    ProcStat: "/proc/stat",
    ProcMeminfo: "/proc/meminfo",
    BacklightClass: "/sys/class/backlight",
});

export const ColorSchemeCommand = Object.freeze({
    schema: "org.gnome.desktop.interface",
    key: "color-scheme",
    dark: "prefer-dark",
    light: "prefer-light",
});
