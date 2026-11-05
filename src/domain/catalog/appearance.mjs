export const INHERIT = "inherit";

export const AppearanceStyle = Object.freeze({ Fluent: "fluent", Flat: "flat" });

export const EffectKnob = Object.freeze({
    Backdrop: "backdrop",
    Grain: "grain",
    EdgeHighlight: "edgeHighlight",
    Shadows: "shadows",
    Corners: "corners",
    Animations: "animations",
    TranslucentOverlays: "translucentOverlays",
    LiveThumbnails: "liveThumbnails",
    ClockSeconds: "clockSeconds",
    BackgroundWork: "backgroundWork",
});

export const Backdrop = Object.freeze({ Solid: "solid", Tint: "tint", Acrylic: "acrylic", Mica: "mica" });
export const Toggle = Object.freeze({ Off: "off", On: "on" });
export const Shadows = Object.freeze({ None: "none", Soft: "soft", Layered: "layered" });
export const Corners = Object.freeze({ Circular: "circular", Continuous: "continuous" });
export const Animations = Object.freeze({ None: "none", Fades: "fades", Full: "full", Rich: "rich" });
export const BackgroundWork = Object.freeze({ Saver: "saver", Normal: "normal" });

const BACKDROP_OPTIONS = Object.freeze([Backdrop.Solid, Backdrop.Tint, Backdrop.Acrylic, Backdrop.Mica]);
const TOGGLE_OPTIONS = Object.freeze([Toggle.Off, Toggle.On]);

export const CostHint = Object.freeze({ None: "none", Memory: "memory", Moving: "cpuWhileMoving", Continuous: "continuous" });

/** @typedef {{ options: readonly string[], cost: string, description: string }} KnobSpec */

/** @type {Readonly<Record<string, KnobSpec>>} */
export const KNOBS = Object.freeze({
    backdrop: { options: BACKDROP_OPTIONS, cost: CostHint.Memory, description: "Surface backdrop: opaque, tinted, compositor-blur acrylic, or wallpaper mica." },
    grain: { options: TOGGLE_OPTIONS, cost: CostHint.None, description: "Faint noise texture on acrylic and mica." },
    edgeHighlight: { options: TOGGLE_OPTIONS, cost: CostHint.None, description: "Gradient edge stroke, lighter on top." },
    shadows: { options: [Shadows.None, Shadows.Soft, Shadows.Layered], cost: CostHint.None, description: "Shadows under flyouts and toasts." },
    corners: { options: [Corners.Circular, Corners.Continuous], cost: CostHint.None, description: "Circular corners or Apple-style continuous corners." },
    animations: { options: [Animations.None, Animations.Fades, Animations.Full, Animations.Rich], cost: CostHint.Moving, description: "No animation, fades only, slides, or slides with scale." },
    translucentOverlays: { options: TOGGLE_OPTIONS, cost: CostHint.None, description: "Translucent tooltips and on-screen displays." },
    liveThumbnails: { options: TOGGLE_OPTIONS, cost: CostHint.Continuous, description: "Live window previews on taskbar hover (also needs experimental.hoverThumbnails)." },
    clockSeconds: { options: TOGGLE_OPTIONS, cost: CostHint.Continuous, description: "Allow a seconds clock (clock.showSeconds)." },
    backgroundWork: { options: [BackgroundWork.Saver, BackgroundWork.Normal], cost: CostHint.Continuous, description: "Saver multiplies polling intervals by appearance.saverPollingFactor." },
});

export const LEVEL_NAMES = Object.freeze(["batterySaver", "light", "balanced", "rich", "maximum"]);
export const DEFAULT_LEVEL = 3;
export const SAME_AS_AC = -1;
export const SAVER_POLLING_FACTOR = 4;

/** @type {Readonly<Record<string, Readonly<Record<string, string>>>>} */
export const LEVEL_BUNDLES = Object.freeze({
    batterySaver: { backdrop: "solid", grain: "off", edgeHighlight: "off", shadows: "none", corners: "circular", animations: "none", translucentOverlays: "off", liveThumbnails: "off", clockSeconds: "off", backgroundWork: "saver" },
    light: { backdrop: "tint", grain: "off", edgeHighlight: "off", shadows: "soft", corners: "circular", animations: "fades", translucentOverlays: "off", liveThumbnails: "off", clockSeconds: "on", backgroundWork: "normal" },
    balanced: { backdrop: "acrylic", grain: "off", edgeHighlight: "on", shadows: "soft", corners: "continuous", animations: "full", translucentOverlays: "on", liveThumbnails: "off", clockSeconds: "on", backgroundWork: "normal" },
    rich: { backdrop: "mica", grain: "on", edgeHighlight: "on", shadows: "layered", corners: "continuous", animations: "full", translucentOverlays: "on", liveThumbnails: "off", clockSeconds: "on", backgroundWork: "normal" },
    maximum: { backdrop: "mica", grain: "on", edgeHighlight: "on", shadows: "layered", corners: "continuous", animations: "rich", translucentOverlays: "on", liveThumbnails: "on", clockSeconds: "on", backgroundWork: "normal" },
});

/** @type {Readonly<Record<string, Readonly<Record<string, string>>>>} */
export const STYLE_VALUES = Object.freeze({
    fluent: {},
    flat: { backdrop: "tint", grain: "off", edgeHighlight: "off", shadows: "soft", corners: "circular" },
});

export const LEVEL_SETTING_KEY = "appearance.level";
export const EffectsTableField = Object.freeze({ Name: "name", Level: "level", Choice: "choice", Result: "result", Cost: "cost" });
export const EFFECTS_TABLE_FIELDS = Object.freeze([EffectsTableField.Name, EffectsTableField.Level, EffectsTableField.Choice, EffectsTableField.Result, EffectsTableField.Cost]);
export const EFFECTS_TABLE_COLUMNS = EFFECTS_TABLE_FIELDS.length;
export const APPEARANCE_SECTION_NAME = "appearance";
