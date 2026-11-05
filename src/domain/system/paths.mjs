const HOME_PREFIX = "~/";
const PATH_SEPARATOR = "/";

/**
 * @param {string} path
 * @param {string} home
 * @returns {string}
 */
export function expandHome(path, home) {
    return path.indexOf(HOME_PREFIX) === 0 ? `${home}${path.slice(1)}` : path;
}

/**
 * @param {string} path
 * @returns {string}
 */
export function parentDirectory(path) {
    const separator = path.lastIndexOf(PATH_SEPARATOR);
    return separator <= 0 ? PATH_SEPARATOR : path.slice(0, separator);
}

/**
 * @param {string} directory
 * @param {string} relative
 * @returns {string}
 */
export function joinPath(directory, relative) {
    return directory.endsWith(PATH_SEPARATOR) ? `${directory}${relative}` : `${directory}${PATH_SEPARATOR}${relative}`;
}
