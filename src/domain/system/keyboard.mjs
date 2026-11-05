/** @typedef {{ name: string, layout: string, main: boolean, capsLock: boolean, numLock: boolean }} KeyboardState */

const LANGUAGE_LETTERS = 3;
const VARIANT_PATTERN = /\(([^)]+)\)/;
const LAYOUT_EVENT_SEPARATOR = ",";
const LOCK_LED = Object.freeze({ capsLock: "capslock", numLock: "numlock" });

/**
 * @param {string} layoutName
 * @returns {{ language: string, variant: string }}
 */
export function abbreviateLayout(layoutName) {
    const trimmed = layoutName.trim();
    if (trimmed === "") {
        return { language: "", variant: "" };
    }
    const variant = VARIANT_PATTERN.exec(trimmed);
    const language = trimmed.replace(VARIANT_PATTERN, "").trim();
    return {
        language: language.slice(0, LANGUAGE_LETTERS).toUpperCase(),
        variant: variant ? variant[1].split(/[\s,]+/)[0].toUpperCase() : "",
    };
}

/**
 * @param {unknown} parsed
 * @returns {KeyboardState | null}
 */
export function mainKeyboard(parsed) {
    const keyboards = parsed && typeof parsed === "object" && Array.isArray(/** @type {{ keyboards?: unknown }} */ (parsed).keyboards) ? /** @type {Record<string, unknown>[]} */ (/** @type {{ keyboards: unknown[] }} */ (parsed).keyboards) : [];
    const chosen = keyboards.find(keyboard => keyboard.main === true) ?? keyboards[0];
    if (!chosen) {
        return null;
    }
    return {
        name: String(chosen.name ?? ""),
        layout: String(chosen.active_keymap ?? ""),
        main: chosen.main === true,
        capsLock: chosen.capsLock === true,
        numLock: chosen.numLock === true,
    };
}

/**
 * @param {string} eventData
 * @returns {string}
 */
export function layoutFromEvent(eventData) {
    const separator = eventData.indexOf(LAYOUT_EVENT_SEPARATOR);
    return separator < 0 ? eventData : eventData.slice(separator + 1);
}

/**
 * @param {string} brightness
 * @returns {boolean}
 */
export function ledIsOn(brightness) {
    const value = Number(brightness.trim());
    return Number.isFinite(value) && value > 0;
}

/**
 * @param {unknown} parsed
 * @returns {number}
 */
export function layoutCountFromOption(parsed) {
    const value = parsed && typeof parsed === "object" ? /** @type {{ str?: unknown }} */ (parsed).str : null;
    return typeof value === "string" ? value.split(LAYOUT_EVENT_SEPARATOR).filter(layout => layout.trim() !== "").length : 0;
}

/**
 * @param {string} output
 * @returns {{ capsLock: boolean | null, numLock: boolean | null }}
 */
export function parseLockLeds(output) {
    /** @type {{ capsLock: boolean | null, numLock: boolean | null }} */
    const state = { capsLock: null, numLock: null };
    output.split("\n").forEach(line => {
        const [name, brightness] = line.split("\t");
        if (name === LOCK_LED.capsLock) {
            state.capsLock = state.capsLock === true || ledIsOn(brightness ?? "");
        } else if (name === LOCK_LED.numLock) {
            state.numLock = state.numLock === true || ledIsOn(brightness ?? "");
        }
    });
    return state;
}

/**
 * @param {{ capsLock: boolean | null, numLock: boolean | null }} previous
 * @param {{ capsLock: boolean | null, numLock: boolean | null }} next
 * @returns {"capsLock" | "numLock" | ""}
 */
export function changedLockKey(previous, next) {
    if (next.capsLock !== null && next.capsLock !== previous.capsLock) {
        return "capsLock";
    }
    if (next.numLock !== null && next.numLock !== previous.numLock) {
        return "numLock";
    }
    return "";
}
