export const SystemBinary = Object.freeze({
    NotifySend: "notify-send",
    Gsettings: "gsettings",
    MakeDirectory: "mkdir",
    Systemctl: "systemctl",
    Loginctl: "loginctl",
    Shell: "sh",
    XdgOpen: "xdg-open",
    Find: "find",
});

export const TexturePath = Object.freeze({ noise: "assets/textures/noise.png" });
export const FILE_URL_PREFIX = "file://";
export const URL_SCHEME_SEPARATOR = "://";

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

export const ProfileSettingKey = Object.freeze({ active: "profiles.active", trustedCommands: "profiles.trustedCommands" });

export const NotifyUrgency = Object.freeze({ Normal: "normal", Critical: "critical" });

export const HttpStatus = Object.freeze({ okMinimum: 200, okMaximum: 299 });
export const HttpError = Object.freeze({ status: "status", timeout: "timeout" });
export const HttpMethod = Object.freeze({ get: "GET" });
export const URL_QUERY_SEPARATOR = "?";
