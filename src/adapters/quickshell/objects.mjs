/**
 * @param {{ values?: unknown[] } | null | undefined} model
 * @returns {unknown[]}
 */
export function valuesOf(model) {
    return model && model.values ? Array.prototype.slice.call(model.values) : [];
}

/**
 * @param {{ defaultAdapter?: unknown } | null | undefined} bluetooth
 * @returns {unknown}
 */
export function defaultAdapterOf(bluetooth) {
    return bluetooth && bluetooth.defaultAdapter ? bluetooth.defaultAdapter : null;
}

/**
 * @param {ArrayLike<unknown> | null | undefined} sequence
 * @returns {unknown[]}
 */
export function toArray(sequence) {
    return sequence ? Array.prototype.slice.call(sequence) : [];
}
