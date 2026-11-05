import { CompositorKind } from "../catalog/enums.mjs";

/**
 * @param {string} configuredKind
 * @param {string} hyprlandSignature
 * @returns {string}
 */
export function selectCompositorKind(configuredKind, hyprlandSignature) {
    if (configuredKind === CompositorKind.Hyprland && hyprlandSignature !== "") {
        return CompositorKind.Hyprland;
    }
    if (configuredKind === CompositorKind.Generic) {
        return CompositorKind.Generic;
    }
    return hyprlandSignature !== "" ? CompositorKind.Hyprland : CompositorKind.Generic;
}
