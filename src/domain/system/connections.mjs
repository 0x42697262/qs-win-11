/** @typedef {{ name: string, uuid: string, active: boolean }} VpnConnection */

const VPN_TYPES = Object.freeze(["vpn", "wireguard"]);
const FIELD_SEPARATOR = ":";
const ESCAPE = "\\";
const ACTIVE_VALUE = "yes";
const VPN_FIELD = Object.freeze({ name: 0, uuid: 1, type: 2, active: 3 });
const VPN_FIELD_COUNT = Object.keys(VPN_FIELD).length;

/**
 * @param {string} line
 * @returns {string[]}
 */
export function splitTerseLine(line) {
    /** @type {string[]} */
    const fields = [];
    let current = "";
    for (let position = 0; position < line.length; position += 1) {
        const character = line.charAt(position);
        if (character === ESCAPE && position + 1 < line.length) {
            current += line.charAt(position + 1);
            position += 1;
        } else if (character === FIELD_SEPARATOR) {
            fields.push(current);
            current = "";
        } else {
            current += character;
        }
    }
    fields.push(current);
    return fields;
}

/**
 * @param {string} output
 * @returns {VpnConnection[]}
 */
export function parseVpnConnections(output) {
    return output.split("\n")
        .map(line => splitTerseLine(line.trim()))
        .filter(fields => fields.length >= VPN_FIELD_COUNT && VPN_TYPES.indexOf(fields[VPN_FIELD.type]) >= 0)
        .map(fields => ({ name: fields[VPN_FIELD.name], uuid: fields[VPN_FIELD.uuid], active: fields[VPN_FIELD.active] === ACTIVE_VALUE }));
}
