import { FEATURE_REQUIREMENTS, FeatureName } from "../catalog/features.mjs";

export const FeatureOffReason = Object.freeze({
    DisabledByUser: "disabledByUser",
    MissingCapability: "missingCapability",
    BusNameTaken: "busNameTaken",
    DependencyOff: "dependencyOff",
});

/** @typedef {import("../catalog/features.mjs").Feature} Feature */
/** @typedef {import("../catalog/features.mjs").CapabilityName} CapabilityName */
/** @typedef {import("../catalog/features.mjs").BusNameValue} BusNameValue */
/** @typedef {{ reason: typeof FeatureOffReason[keyof typeof FeatureOffReason], detail: string }} FeatureOff */
/** @typedef {{ enabled: Readonly<Record<Feature, boolean>>, offReasons: Readonly<Partial<Record<Feature, FeatureOff>>> }} FeatureSet */

/**
 * @param {Readonly<Record<string, boolean>>} flags
 * @param {ReadonlySet<CapabilityName>} capabilities
 * @param {ReadonlySet<BusNameValue>} takenBusNames
 * @returns {FeatureSet}
 */
export function resolveFeatures(flags, capabilities, takenBusNames) {
    /** @type {Partial<Record<Feature, boolean>>} */
    const enabled = {};
    /** @type {Partial<Record<Feature, FeatureOff>>} */
    const offReasons = {};

    /**
     * @param {Feature} feature
     * @param {ReadonlySet<Feature>} visiting
     * @returns {boolean}
     */
    function resolve(feature, visiting) {
        const known = enabled[feature];
        if (known !== undefined) {
            return known;
        }
        const requirement = FEATURE_REQUIREMENTS[feature];
        const missingCapability = requirement.capabilities.find((capability) => !capabilities.has(capability));
        const offDependency = requirement.dependsOn.find((dependency) => visiting.has(dependency) || !resolve(dependency, new Set([...visiting, feature])));
        /** @type {FeatureOff | undefined} */
        let off;
        if (flags[feature] !== true) {
            off = { reason: FeatureOffReason.DisabledByUser, detail: "" };
        } else if (missingCapability) {
            off = { reason: FeatureOffReason.MissingCapability, detail: missingCapability };
        } else if (requirement.busName && takenBusNames.has(requirement.busName)) {
            off = { reason: FeatureOffReason.BusNameTaken, detail: requirement.busName };
        } else if (offDependency) {
            off = { reason: FeatureOffReason.DependencyOff, detail: offDependency };
        }
        enabled[feature] = off === undefined;
        if (off) {
            offReasons[feature] = off;
        }
        return off === undefined;
    }

    Object.values(FeatureName).forEach((feature) => resolve(feature, new Set()));
    return {
        enabled: /** @type {Readonly<Record<Feature, boolean>>} */ (Object.freeze(enabled)),
        offReasons: Object.freeze(offReasons),
    };
}
