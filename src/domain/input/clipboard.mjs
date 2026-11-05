/** @typedef {{ id: string, preview: string, isImage: boolean, line: string }} ClipboardEntry */
/** @typedef {{ char: string, name: string }} Emoji */
/** @typedef {{ name: string, emoji: Emoji[] }} EmojiGroup */

const FIELD_SEPARATOR = "\t";
const BINARY_PREVIEW = /^\[\[\s*binary data/;
const IMAGE_TYPES = /\b(png|jpe?g|webp|gif|bmp)\b/i;

/**
 * @param {string} output
 * @param {number} limit
 * @returns {ClipboardEntry[]}
 */
export function parseCliphistList(output, limit) {
    return output.split("\n")
        .filter(line => line.indexOf(FIELD_SEPARATOR) > 0)
        .slice(0, Math.max(0, limit))
        .map(line => {
            const separator = line.indexOf(FIELD_SEPARATOR);
            const preview = line.slice(separator + 1);
            return { id: line.slice(0, separator), preview, isImage: BINARY_PREVIEW.test(preview) && IMAGE_TYPES.test(preview), line };
        });
}

/**
 * @param {unknown} parsed
 * @returns {EmojiGroup[]}
 */
export function emojiGroups(parsed) {
    const groups = parsed && typeof parsed === "object" ? /** @type {{ groups?: unknown }} */ (parsed).groups : null;
    return Array.isArray(groups) ? /** @type {EmojiGroup[]} */ (groups.filter(group => group && typeof group.name === "string" && Array.isArray(group.emoji))) : [];
}

/**
 * @param {readonly EmojiGroup[]} groups
 * @param {string} query
 * @param {number} limit
 * @returns {Emoji[]}
 */
export function searchEmoji(groups, query, limit) {
    const words = query.trim().toLowerCase().split(/\s+/).filter(word => word !== "");
    if (words.length === 0) {
        return [];
    }
    /** @type {{ emoji: Emoji, score: number }[]} */
    const found = [];
    groups.forEach(group => group.emoji.forEach(emoji => {
        const name = emoji.name.toLowerCase();
        if (words.every(word => name.indexOf(word) >= 0)) {
            const starts = name.split(/[\s:-]+/).some(part => part.indexOf(words[0]) === 0);
            found.push({ emoji, score: (name.indexOf(words[0]) === 0 ? 0 : starts ? 1 : 2) * name.length });
        }
    }));
    return found.sort((left, right) => left.score - right.score).slice(0, Math.max(0, limit)).map(entry => entry.emoji);
}
