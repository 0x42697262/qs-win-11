const DEGREES_PER_RADIAN = 180 / Math.PI;
const RIGHT_ANGLE = 90;
const HALF_RIGHT_ANGLE = 45;
const THIRD = 3;
const PRECISION = 1000;

export const CornerModel = Object.freeze({ Smoothing: "smoothing", Superellipse: "superellipse" });

/**
 * @param {number} degrees
 * @returns {number}
 */
function radians(degrees) {
    return degrees / DEGREES_PER_RADIAN;
}

/**
 * @param {number} value
 * @returns {number}
 */
function round(value) {
    return Math.round(value * PRECISION) / PRECISION;
}

/** @typedef {{ lead: number, step: number, run: number, rise: number, extent: number, arc: number, radius: number }} CornerParams */

/**
 * @param {number} width
 * @param {number} height
 * @param {number} radius
 * @param {number} smoothing
 * @returns {CornerParams}
 */
export function smoothCornerParams(width, height, radius, smoothing) {
    const budget = Math.max(0, Math.min(width, height) / 2);
    const cornerRadius = Math.max(0, Math.min(radius, budget));
    const maximumSmoothing = cornerRadius > 0 ? budget / cornerRadius - 1 : 0;
    const smooth = Math.max(0, Math.min(smoothing, maximumSmoothing, 1));
    const extent = Math.min((1 + smooth) * cornerRadius, budget);
    const arcMeasure = RIGHT_ANGLE * (1 - smooth);
    const arc = Math.sin(radians(arcMeasure / 2)) * cornerRadius * Math.SQRT2;
    const angleAlpha = (RIGHT_ANGLE - arcMeasure) / 2;
    const p3ToP4 = cornerRadius * Math.tan(radians(angleAlpha / 2));
    const angleBeta = HALF_RIGHT_ANGLE * smooth;
    const run = p3ToP4 * Math.cos(radians(angleBeta));
    const rise = run * Math.tan(radians(angleBeta));
    const step = (extent - arc - run - rise) / THIRD;
    return { lead: 2 * step, step, run, rise, extent, arc, radius: cornerRadius };
}

/**
 * @param {number} width
 * @param {number} height
 * @param {number} radius
 * @param {number} smoothing
 * @returns {string}
 */
export function smoothRectanglePath(width, height, radius, smoothing) {
    const params = smoothCornerParams(width, height, radius, smoothing);
    const lead = round(params.lead);
    const rise = round(params.rise);
    const run = round(params.run);
    const extent = round(params.extent);
    const arc = round(params.arc);
    const cornerRadius = round(params.radius);
    const total = round(params.lead + params.step + params.run);
    const stepRun = round(params.step + params.run);
    const leadStep = round(params.lead + params.step);
    return [
        `M ${round(width - params.extent)} 0`,
        `c ${lead} 0 ${leadStep} 0 ${total} ${rise}`,
        `a ${cornerRadius} ${cornerRadius} 0 0 1 ${arc} ${arc}`,
        `c ${rise} ${run} ${rise} ${stepRun} ${rise} ${total}`,
        `L ${round(width)} ${round(height - params.extent)}`,
        `c 0 ${lead} 0 ${leadStep} ${-rise} ${total}`,
        `a ${cornerRadius} ${cornerRadius} 0 0 1 ${-arc} ${arc}`,
        `c ${-run} ${rise} ${-stepRun} ${rise} ${-total} ${rise}`,
        `L ${extent} ${round(height)}`,
        `c ${-lead} 0 ${-leadStep} 0 ${-total} ${-rise}`,
        `a ${cornerRadius} ${cornerRadius} 0 0 1 ${-arc} ${-arc}`,
        `c ${-rise} ${-run} ${-rise} ${-stepRun} ${-rise} ${-total}`,
        `L 0 ${extent}`,
        `c 0 ${-lead} 0 ${-leadStep} ${rise} ${-total}`,
        `a ${cornerRadius} ${cornerRadius} 0 0 1 ${arc} ${-arc}`,
        `c ${run} ${-rise} ${stepRun} ${-rise} ${total} ${-rise}`,
        "Z",
    ].join(" ");
}

/**
 * @param {number} width
 * @param {number} height
 * @param {number} radius
 * @param {number} exponent
 * @param {number} segments
 * @returns {string}
 */
export function superellipseRectanglePath(width, height, radius, exponent, segments) {
    const cornerRadius = Math.max(0, Math.min(radius, Math.min(width, height) / 2));
    const steps = Math.max(1, Math.round(segments));
    const power = 2 / Math.max(exponent, 1);
    const corners = [
        { centerX: width - cornerRadius, centerY: cornerRadius, signX: 1, signY: -1 },
        { centerX: width - cornerRadius, centerY: height - cornerRadius, signX: 1, signY: 1 },
        { centerX: cornerRadius, centerY: height - cornerRadius, signX: -1, signY: 1 },
        { centerX: cornerRadius, centerY: cornerRadius, signX: -1, signY: -1 },
    ];
    /** @type {string[]} */
    const points = [];
    corners.forEach((corner, cornerIndex) => {
        for (let step = 0; step <= steps; step += 1) {
            const fraction = step / steps;
            const theta = radians(RIGHT_ANGLE * fraction);
            const along = cornerIndex % 2 === 0 ? Math.sin(theta) : Math.cos(theta);
            const across = cornerIndex % 2 === 0 ? Math.cos(theta) : Math.sin(theta);
            const pointX = corner.centerX + corner.signX * cornerRadius * Math.pow(along, power);
            const pointY = corner.centerY + corner.signY * cornerRadius * Math.pow(across, power);
            points.push(`${points.length === 0 ? "M" : "L"} ${round(pointX)} ${round(pointY)}`);
        }
    });
    return `${points.join(" ")} Z`;
}

/**
 * @param {string} model
 * @param {number} width
 * @param {number} height
 * @param {number} radius
 * @param {{ smoothing: number, exponent: number, segments: number }} options
 * @returns {string}
 */
export function cornerPath(model, width, height, radius, options) {
    return model === CornerModel.Superellipse
        ? superellipseRectanglePath(width, height, radius, options.exponent, options.segments)
        : smoothRectanglePath(width, height, radius, options.smoothing);
}
