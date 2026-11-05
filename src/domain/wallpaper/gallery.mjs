/** @typedef {{ path: string, name: string }} WallpaperFile */

const IMAGE_EXTENSIONS = Object.freeze(["jpg", "jpeg", "png", "webp", "bmp", "gif"]);
const FIND_BINARY = "find";
const PATH_SEPARATOR = "/";
const EXTENSION_SEPARATOR = ".";

/**
 * @param {string} directory
 * @param {number} depth
 * @returns {string[]}
 */
export function wallpaperFindCommand(directory, depth) {
    /** @type {string[]} */
    const names = [];
    IMAGE_EXTENSIONS.forEach((extension, index) => {
        if (index > 0) {
            names.push("-o");
        }
        names.push("-iname", `*.${extension}`);
    });
    return [FIND_BINARY, "-L", directory, "-maxdepth", String(Math.max(1, Math.round(depth))), "-type", "f", "("].concat(names, [")"]);
}

/**
 * @param {string} path
 * @returns {string}
 */
export function wallpaperName(path) {
    const base = path.slice(path.lastIndexOf(PATH_SEPARATOR) + 1);
    const dot = base.lastIndexOf(EXTENSION_SEPARATOR);
    return dot > 0 ? base.slice(0, dot) : base;
}

/**
 * @param {string} output
 * @param {number} limit
 * @returns {WallpaperFile[]}
 */
export function parseWallpaperList(output, limit) {
    return output.split("\n")
        .map(line => line.trim())
        .filter(line => line !== "")
        .sort((left, right) => wallpaperName(left).localeCompare(wallpaperName(right)))
        .slice(0, Math.max(0, limit))
        .map(path => ({ path, name: wallpaperName(path) }));
}
