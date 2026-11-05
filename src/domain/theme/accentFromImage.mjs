import { formatHex } from "./color.mjs";

/** @typedef {{ hueBuckets: number, minSaturation: number, minValue: number, lightnessMin: number, lightnessMax: number, saturationMin: number }} AccentOptions */
/** @typedef {{ hue: number, saturation: number, lightness: number }} Hsl */

const CHANNEL_MAX = 255;
const CHANNELS = 4;
const ALPHA_OFFSET = 3;
const DEGREES = 360;
const HUE_SECTOR = 60;
const GREEN_SECTOR_OFFSET = 2;
const BLUE_SECTOR_OFFSET = 4;
const SECTORS = 6;
const OPAQUE_ENOUGH = 128;

/**
 * @param {number} red
 * @param {number} green
 * @param {number} blue
 * @returns {Hsl}
 */
export function rgbToHsl(red, green, blue) {
    const scaledRed = red / CHANNEL_MAX;
    const scaledGreen = green / CHANNEL_MAX;
    const scaledBlue = blue / CHANNEL_MAX;
    const maximum = Math.max(scaledRed, scaledGreen, scaledBlue);
    const minimum = Math.min(scaledRed, scaledGreen, scaledBlue);
    const lightness = (maximum + minimum) / 2;
    const delta = maximum - minimum;
    if (delta === 0) {
        return { hue: 0, saturation: 0, lightness };
    }
    const saturation = delta / (1 - Math.abs(2 * lightness - 1));
    let sector = 0;
    if (maximum === scaledRed) {
        sector = ((scaledGreen - scaledBlue) / delta) % SECTORS;
    } else if (maximum === scaledGreen) {
        sector = (scaledBlue - scaledRed) / delta + GREEN_SECTOR_OFFSET;
    } else {
        sector = (scaledRed - scaledGreen) / delta + BLUE_SECTOR_OFFSET;
    }
    return { hue: (sector * HUE_SECTOR + DEGREES) % DEGREES, saturation, lightness };
}

/**
 * @param {Hsl} color
 * @returns {string}
 */
export function hslToHex(color) {
    const chroma = (1 - Math.abs(2 * color.lightness - 1)) * color.saturation;
    const sector = color.hue / HUE_SECTOR;
    const second = chroma * (1 - Math.abs((sector % 2) - 1));
    const offset = color.lightness - chroma / 2;
    const table = [[chroma, second, 0], [second, chroma, 0], [0, chroma, second], [0, second, chroma], [second, 0, chroma], [chroma, 0, second]];
    const [red, green, blue] = table[Math.floor(sector) % SECTORS];
    return formatHex({ red: (red + offset) * CHANNEL_MAX, green: (green + offset) * CHANNEL_MAX, blue: (blue + offset) * CHANNEL_MAX });
}

/**
 * @param {ArrayLike<number>} pixels
 * @param {AccentOptions} options
 * @returns {string | null}
 */
export function extractAccent(pixels, options) {
    const buckets = Math.max(1, Math.round(options.hueBuckets));
    const weights = new Array(buckets).fill(0);
    const sums = new Array(buckets).fill(0).map(() => ({ hueX: 0, hueY: 0, saturation: 0, lightness: 0 }));
    for (let offset = 0; offset + ALPHA_OFFSET < pixels.length; offset += CHANNELS) {
        if (pixels[offset + ALPHA_OFFSET] < OPAQUE_ENOUGH) {
            continue;
        }
        const red = pixels[offset];
        const green = pixels[offset + 1];
        const blue = pixels[offset + 2];
        const value = Math.max(red, green, blue) / CHANNEL_MAX;
        const color = rgbToHsl(red, green, blue);
        if (color.saturation < options.minSaturation || value < options.minValue) {
            continue;
        }
        const bucket = Math.min(buckets - 1, Math.floor(color.hue / DEGREES * buckets));
        const weight = color.saturation * value;
        const radians = color.hue / DEGREES * Math.PI * 2;
        weights[bucket] += weight;
        sums[bucket].hueX += Math.cos(radians) * weight;
        sums[bucket].hueY += Math.sin(radians) * weight;
        sums[bucket].saturation += color.saturation * weight;
        sums[bucket].lightness += color.lightness * weight;
    }
    const best = weights.indexOf(Math.max.apply(null, weights));
    if (best < 0 || weights[best] <= 0) {
        return null;
    }
    const total = weights[best];
    const sum = sums[best];
    const hue = (Math.atan2(sum.hueY, sum.hueX) / (Math.PI * 2) * DEGREES + DEGREES) % DEGREES;
    return hslToHex({
        hue,
        saturation: Math.max(options.saturationMin, Math.min(1, sum.saturation / total)),
        lightness: Math.max(options.lightnessMin, Math.min(options.lightnessMax, sum.lightness / total)),
    });
}

const MAGICK_PIXEL = /^\d+,\d+:\s*\(\s*([\d.]+)\s*,\s*([\d.]+)\s*,\s*([\d.]+)\s*(?:,\s*([\d.]+)\s*)?\)/;
const FULL_ALPHA = 255;

/**
 * @param {string} output
 * @returns {number[]}
 */
export function parseMagickPixels(output) {
    /** @type {number[]} */
    const pixels = [];
    output.split("\n").forEach(line => {
        const match = MAGICK_PIXEL.exec(line.trim());
        if (match) {
            const [, red, green, blue, alpha] = match;
            pixels.push(Number(red), Number(green), Number(blue), alpha === undefined ? FULL_ALPHA : Number(alpha));
        }
    });
    return pixels;
}

/**
 * @param {string} binary
 * @param {string} path
 * @param {number} sampleSize
 * @returns {string[]}
 */
export function magickSampleCommand(binary, path, sampleSize) {
    const size = Math.max(1, Math.round(sampleSize));
    return [binary, path, "-alpha", "on", "-resize", `${size}x${size}!`, "-depth", "8", "txt:-"];
}
