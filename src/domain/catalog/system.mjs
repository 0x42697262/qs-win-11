export const SystemBinary = Object.freeze({
    NotifySend: "notify-send",
    Gsettings: "gsettings",
    MakeDirectory: "mkdir",
    Systemctl: "systemctl",
    Loginctl: "loginctl",
    Shell: "sh",
    XdgOpen: "xdg-open",
    Find: "find",
    Nmcli: "nmcli",
    Ddcutil: "ddcutil",
    Hyprctl: "hyprctl",
    Magick: "magick",
    Cava: "cava",
    Df: "df",
    Convert: "convert",
});

export const APP_THEMES_DIRECTORY = "themes";
export const APP_TEMPLATES_DIRECTORY = "templates";
export const TEMPLATE_FIND_ARGUMENTS = Object.freeze(["-maxdepth", "1", "-name", "*.tmpl"]);

export const GPU_USAGE_COMMAND = Object.freeze(["sh", "-c", "for file in /sys/class/drm/card*/device/gpu_busy_percent; do [ -r \"$file\" ] && { printf 'amd %s\\n' \"$(cat \"$file\")\"; exit 0; }; done; command -v nvidia-smi >/dev/null 2>&1 && printf 'nvidia %s\\n' \"$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n 1)\"; true"]);
export const DF_ARGUMENTS = Object.freeze(["-P", "-B1"]);
export const CAVA_CONFIG_FILE = "qs-win-11-cava.conf";

export const NmcliCommand = Object.freeze({
    list: Object.freeze(["nmcli", "-t", "-f", "NAME,UUID,TYPE,ACTIVE", "connection", "show"]),
    up: Object.freeze(["nmcli", "connection", "up", "uuid"]),
    down: Object.freeze(["nmcli", "connection", "down", "uuid"]),
});

export const DdcCommand = Object.freeze({
    detect: Object.freeze(["ddcutil", "detect", "--brief"]),
    busFlag: "--bus",
    getBrightness: Object.freeze(["getvcp", "10", "--brief"]),
    setBrightness: Object.freeze(["setvcp", "10"]),
});

export const HyprctlCommand = Object.freeze({
    devices: Object.freeze(["hyprctl", "devices", "-j"]),
    layoutOption: Object.freeze(["hyprctl", "getoption", "input:kb_layout", "-j"]),
    nextLayout: Object.freeze(["hyprctl", "switchxkblayout", "all", "next"]),
});

export const LOCK_KEY_LED_COMMAND = Object.freeze(["sh", "-c", "for led in /sys/class/leds/*::capslock /sys/class/leds/*::numlock; do [ -r \"$led/brightness\" ] && printf '%s\\t%s\\n' \"${led##*::}\" \"$(cat \"$led/brightness\")\"; done; true"]);

export const TexturePath = Object.freeze({ noise: "assets/textures/noise.png" });
export const FILE_URL_PREFIX = "file://";
export const URL_SCHEME_SEPARATOR = "://";

export const SystemPath = Object.freeze({
    OwnProcessStat: "/proc/self/stat",
    ProcStat: "/proc/stat",
    ProcMeminfo: "/proc/meminfo",
    ProcNetDev: "/proc/net/dev",
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

export const ICON_FIND_ARGUMENTS = Object.freeze(["-path", "*/apps/*", "(", "-name", "*.svg", "-o", "-name", "*.png", ")"]);

export const NotifyUrgency = Object.freeze({ Normal: "normal", Critical: "critical" });

export const HttpStatus = Object.freeze({ okMinimum: 200, okMaximum: 299 });
export const HttpError = Object.freeze({ status: "status", timeout: "timeout" });
export const HttpMethod = Object.freeze({ get: "GET" });
export const URL_QUERY_SEPARATOR = "?";
