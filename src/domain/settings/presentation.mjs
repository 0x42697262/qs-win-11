const CAMEL_BOUNDARY = /([a-z0-9])([A-Z])/g;
const DOT = ".";
const LIST_SEPARATOR = ",";

/**
 * @param {string} identifier
 * @returns {string}
 */
export function humanize(identifier) {
    const words = identifier.replace(CAMEL_BOUNDARY, "$1 $2").toLowerCase();
    return words.charAt(0).toUpperCase() + words.slice(1);
}

/**
 * @template {{ key: string, label: string, description: string, section: string }} Definition
 * @param {readonly Definition[]} definitions
 * @param {string} section
 * @param {string} query
 * @param {Readonly<Record<string, unknown>> | null} [onlyChangedIn]
 * @returns {Definition[]}
 */
export function visibleDefinitions(definitions, section, query, onlyChangedIn = null) {
    const needle = query.trim().toLowerCase();
    const changed = onlyChangedIn ? definitions.filter((definition) => definition.key in onlyChangedIn) : definitions.slice();
    if (needle !== "") {
        return changed.filter((definition) => `${definition.label} ${definition.description} ${definition.key}`.toLowerCase().includes(needle));
    }
    return onlyChangedIn ? changed : changed.filter((definition) => definition.section === section);
}

/**
 * @param {readonly { section: string }[]} definitions
 * @returns {string[]}
 */
export function sectionsOf(definitions) {
    /** @type {string[]} */
    const sections = [];
    definitions.forEach((definition) => {
        if (!sections.includes(definition.section)) {
            sections.push(definition.section);
        }
    });
    return sections;
}

/**
 * @param {string} key
 * @returns {string}
 */
export function featureNameFromKey(key) {
    const parts = key.split(DOT);
    return parts.length > 1 ? (parts[1] ?? "") : "";
}

/**
 * @param {string} text
 * @returns {string[]}
 */
export function parseListText(text) {
    return text.split(LIST_SEPARATOR).map((item) => item.trim()).filter((item) => item !== "");
}
