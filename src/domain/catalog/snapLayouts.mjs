/** @typedef {{ x: number, y: number, width: number, height: number }} FractionRect */
/** @typedef {{ name: string, zones: readonly FractionRect[] }} SnapLayout */

const HALF = 0.5;
const THIRD = 1 / 3;
const TWO_THIRDS = 2 / 3;

/**
 * @param {number} left
 * @param {number} top
 * @param {number} width
 * @param {number} height
 * @returns {FractionRect}
 */
function zone(left, top, width, height) {
    return Object.freeze({ x: left, y: top, width, height });
}

/** @type {readonly SnapLayout[]} */
export const SNAP_LAYOUTS = Object.freeze([
    { name: "halves", zones: [zone(0, 0, HALF, 1), zone(HALF, 0, HALF, 1)] },
    { name: "twoThirdsLeft", zones: [zone(0, 0, TWO_THIRDS, 1), zone(TWO_THIRDS, 0, THIRD, 1)] },
    { name: "thirds", zones: [zone(0, 0, THIRD, 1), zone(THIRD, 0, THIRD, 1), zone(TWO_THIRDS, 0, THIRD, 1)] },
    { name: "halfAndQuarters", zones: [zone(0, 0, HALF, 1), zone(HALF, 0, HALF, HALF), zone(HALF, HALF, HALF, HALF)] },
    { name: "quarters", zones: [zone(0, 0, HALF, HALF), zone(HALF, 0, HALF, HALF), zone(0, HALF, HALF, HALF), zone(HALF, HALF, HALF, HALF)] },
]);

export const SNAP_GAP_PIXELS = 8;

export const HyprlandPlacement = Object.freeze({
    classicFloat: "setfloating",
    classicResize: "resizewindowpixel exact",
    classicMove: "movewindowpixel exact",
    luaFloat: "hl.dsp.window.float",
    luaResize: "hl.dsp.window.resize",
    luaMove: "hl.dsp.window.move",
    luaFloatAction: "set",
    addressPrefix: "address:",
    hexPrefix: "0x",
});
