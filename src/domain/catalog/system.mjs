export const SystemBinary = Object.freeze({
    NotifySend: "notify-send",
    Gsettings: "gsettings",
    MakeDirectory: "mkdir",
    Systemctl: "systemctl",
    Loginctl: "loginctl",
    Shell: "sh",
    XdgOpen: "xdg-open",
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

export const SessionCommand = Object.freeze({
    suspend: ["systemctl", "suspend"],
    hibernate: ["systemctl", "hibernate"],
    reboot: ["systemctl", "reboot"],
    powerOff: ["systemctl", "poweroff"],
    terminateSession: ["loginctl", "terminate-session"],
});

export const AvatarPaths = Object.freeze({
    homeFace: ".face",
    accountsServiceDirectory: "/var/lib/AccountsService/icons",
});

export const SessionAction = Object.freeze({
    Lock: "lock",
    Suspend: "suspend",
    Hibernate: "hibernate",
    SignOut: "signOut",
    Restart: "restart",
    PowerOff: "powerOff",
});

export const BRIGHTNESS_PERCENT_PLACEHOLDER = "{percent}";

export const BacklightFile = Object.freeze({ current: "brightness", maximum: "max_brightness" });

export const SystemBusName = Object.freeze({
    PowerProfiles: "org.freedesktop.UPower.PowerProfiles",
    LegacyPowerProfiles: "net.hadess.PowerProfiles",
});
