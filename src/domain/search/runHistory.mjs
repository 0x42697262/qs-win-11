/**
 * @param {readonly string[]} history
 * @param {string} command
 * @param {number} limit
 * @returns {string[]}
 */
export function rememberCommand(history, command, limit) {
    const trimmed = command.trim();
    if (trimmed === "" || limit <= 0) {
        return history.slice(0, Math.max(0, limit));
    }
    return [trimmed].concat(history.filter(entry => entry !== trimmed)).slice(0, limit);
}
