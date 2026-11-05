import { normalizeAppId } from "./appIds.mjs";

const OVERRIDE_SEPARATOR = "=";
const IMAGE_PREFIX = "image:";
const PATH_ROOT = "/";
const URL_SCHEME = "://";
const FILE_URL = "file://";
const SCALABLE = "/scalable/";
const SIZE_PATTERN = new RegExp(String.raw`/(\d+)x\d+(?:@\d+)?/`);
const EXTENSION_PATTERN = /\.(svg|png)$/;
const SCALABLE_RANK = 100000;
const ICONS_SUBDIRECTORY = "icons";
const LEGACY_ICONS_DIRECTORY = ".icons";
const DATA_DIRS_SEPARATOR = ":";

/**
 * @param {readonly string[]} entries
 * @returns {Readonly<Record<string, string>>}
 */
export function parseAppIconOverrides(entries) {
    /** @type {Record<string, string>} */
    const map = {};
    entries.forEach((entry) => {
        const separator = entry.indexOf(OVERRIDE_SEPARATOR);
        if (separator > 0) {
            map[normalizeAppId(entry.slice(0, separator))] = entry.slice(separator + 1).trim();
        }
    });
    return Object.freeze(map);
}

/**
 * @param {string} spec
 * @returns {{ isFile: boolean, value: string }}
 */
export function classifyIconSpec(spec) {
    const raw = spec.indexOf(IMAGE_PREFIX) === 0 ? spec.slice(IMAGE_PREFIX.length) : spec;
    if (raw.indexOf(URL_SCHEME) >= 0) {
        return { isFile: true, value: raw };
    }
    if (raw.indexOf(PATH_ROOT) === 0) {
        return { isFile: true, value: `${FILE_URL}${raw}` };
    }
    return { isFile: false, value: raw };
}

/**
 * @param {string} path
 * @returns {number}
 */
function rank(path) {
    if (path.indexOf(SCALABLE) >= 0) {
        return SCALABLE_RANK;
    }
    const match = SIZE_PATTERN.exec(path);
    return match ? Number(match[1]) : 0;
}

/**
 * @param {string} findOutput
 * @returns {Readonly<Record<string, string>>}
 */
export function buildIconIndex(findOutput) {
    /** @type {Record<string, { path: string, rank: number }>} */
    const best = {};
    findOutput.split("\n").forEach((path) => {
        const trimmed = path.trim();
        if (!EXTENSION_PATTERN.test(trimmed)) {
            return;
        }
        const fileName = trimmed.slice(trimmed.lastIndexOf(PATH_ROOT) + 1).replace(EXTENSION_PATTERN, "");
        const pathRank = rank(trimmed);
        const current = best[fileName];
        if (!current || pathRank > current.rank) {
            best[fileName] = { path: trimmed, rank: pathRank };
        }
    });
    /** @type {Record<string, string>} */
    const index = {};
    Object.keys(best).forEach((name) => { index[name] = `${FILE_URL}${best[name]?.path ?? ""}`; });
    return Object.freeze(index);
}

/**
 * @param {string} dataHome
 * @param {string} dataDirs
 * @param {string} home
 * @param {string} theme
 * @returns {string[]}
 */
export function iconThemeDirectories(dataHome, dataDirs, home, theme) {
    return [`${dataHome}/${ICONS_SUBDIRECTORY}/${theme}`, `${home}/${LEGACY_ICONS_DIRECTORY}/${theme}`]
        .concat(dataDirs.split(DATA_DIRS_SEPARATOR).filter((dir) => dir !== "").map((dir) => `${dir}/${ICONS_SUBDIRECTORY}/${theme}`));
}
