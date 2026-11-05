const BOOKMARK_PATTERN = /<bookmark\s+([^>]*)>/g;
const ATTRIBUTE_PATTERN = /(\w+)="([^"]*)"/g;
const FILE_SCHEME = "file://";
const PATH_SEPARATOR = "/";

/** @typedef {{ uri: string, name: string, modifiedMs: number }} RecentFile */

/**
 * @param {string} text
 * @returns {string}
 */
function decodeXmlEntities(text) {
    return text.split("&amp;").join("&").split("&quot;").join("\"").split("&apos;").join("'").split("&lt;").join("<").split("&gt;").join(">");
}

/**
 * @param {string} uri
 * @returns {string}
 */
export function fileNameFromUri(uri) {
    const path = uri.startsWith(FILE_SCHEME) ? uri.slice(FILE_SCHEME.length) : uri;
    const segments = path.split(PATH_SEPARATOR).filter((segment) => segment !== "");
    try {
        return decodeURIComponent(segments[segments.length - 1] ?? path);
    } catch (decodeError) {
        return segments[segments.length - 1] ?? path;
    }
}

/**
 * @param {string} xml
 * @param {number} limit
 * @returns {RecentFile[]}
 */
export function parseRecentFiles(xml, limit) {
    /** @type {RecentFile[]} */
    const files = [];
    let bookmark = BOOKMARK_PATTERN.exec(xml);
    while (bookmark) {
        /** @type {Record<string, string>} */
        const attributes = {};
        const attributeText = bookmark[1] ?? "";
        let attribute = ATTRIBUTE_PATTERN.exec(attributeText);
        while (attribute) {
            attributes[attribute[1] ?? ""] = decodeXmlEntities(attribute[2] ?? "");
            attribute = ATTRIBUTE_PATTERN.exec(attributeText);
        }
        ATTRIBUTE_PATTERN.lastIndex = 0;
        const uri = attributes.href ?? "";
        if (uri.startsWith(FILE_SCHEME)) {
            files.push({ uri, name: fileNameFromUri(uri), modifiedMs: Date.parse(attributes.modified ?? "") || 0 });
        }
        bookmark = BOOKMARK_PATTERN.exec(xml);
    }
    BOOKMARK_PATTERN.lastIndex = 0;
    return files.sort((left, right) => right.modifiedMs - left.modifiedMs).slice(0, limit);
}
