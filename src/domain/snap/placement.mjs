import { HyprlandPlacement } from "../catalog/snapLayouts.mjs";

/** @typedef {import("../catalog/snapLayouts.mjs").FractionRect} FractionRect */
/** @typedef {{ x: number, y: number, width: number, height: number }} PixelRect */
/** @typedef {{ x: number, y: number, width: number, height: number, scale: number, reserved: readonly number[] }} MonitorGeometry */

const RESERVED_LEFT = 0;
const RESERVED_TOP = 1;
const RESERVED_RIGHT = 2;
const RESERVED_BOTTOM = 3;

/**
 * @param {MonitorGeometry} monitor
 * @param {FractionRect} zone
 * @param {number} gap
 * @returns {PixelRect}
 */
export function placementRect(monitor, zone, gap) {
    const scale = monitor.scale > 0 ? monitor.scale : 1;
    const left = monitor.reserved[RESERVED_LEFT] ?? 0;
    const top = monitor.reserved[RESERVED_TOP] ?? 0;
    const usableWidth = monitor.width / scale - left - (monitor.reserved[RESERVED_RIGHT] ?? 0);
    const usableHeight = monitor.height / scale - top - (monitor.reserved[RESERVED_BOTTOM] ?? 0);
    const half = gap / 2;
    return {
        x: Math.round(monitor.x + left + zone.x * usableWidth + half),
        y: Math.round(monitor.y + top + zone.y * usableHeight + half),
        width: Math.round(zone.width * usableWidth - gap),
        height: Math.round(zone.height * usableHeight - gap),
    };
}

/**
 * @param {string} address
 * @param {PixelRect} rect
 * @param {boolean} usingLua
 * @param {boolean} alreadyFloating
 * @returns {string[]}
 */
export function hyprlandPlacementCommands(address, rect, usingLua, alreadyFloating) {
    const bare = address.startsWith(HyprlandPlacement.hexPrefix) ? address.slice(HyprlandPlacement.hexPrefix.length) : address;
    const target = `${HyprlandPlacement.addressPrefix}${HyprlandPlacement.hexPrefix}${bare}`;
    if (usingLua) {
        const selector = `window = "${target}"`;
        const commands = [
            `${HyprlandPlacement.luaResize}({ x = ${rect.width}, y = ${rect.height}, relative = false, ${selector} })`,
            `${HyprlandPlacement.luaMove}({ x = ${rect.x}, y = ${rect.y}, relative = false, ${selector} })`,
        ];
        return alreadyFloating ? commands : [`${HyprlandPlacement.luaFloat}({ action = "${HyprlandPlacement.luaFloatAction}", ${selector} })`].concat(commands);
    }
    const commands = [
        `${HyprlandPlacement.classicResize} ${rect.width} ${rect.height},${target}`,
        `${HyprlandPlacement.classicMove} ${rect.x} ${rect.y},${target}`,
    ];
    return alreadyFloating ? commands : [`${HyprlandPlacement.classicFloat} ${target}`].concat(commands);
}
